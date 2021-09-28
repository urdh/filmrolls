require 'yaml'

module Filmrolls
  module Metadata
    class Parser
      def self.load(io)
        doc = YAML.safe_load(io)
        # Data validation, sort of
        raise KeyError, 'YAML input missing `author` key' unless doc.key?('author')
        raise KeyError, 'YAML input missing `author.name` key' unless doc['author'].key?('name')
        raise NameError, "YAML input has invalid license `#{doc['license']}`" unless valid_license?(doc['license'])

        # Output construction
        {
          author: doc['author']['name'],
          copyright: get_copyright(doc['author']['name'], doc['license']),
          author_url: doc['license'].nil? ? nil : doc['author']['url'],
          license_url: get_license_url(doc['license']),
          marked: !public_domain?(doc['license']),
          usage_terms: get_usage_terms(doc['author']['name'], doc['license'])
        }.delete_if { |_k, v| v.nil? }
      end

      class << self
        private

        def valid_license?(license)
          license.nil? or LICENSES.key?(license.to_sym)
        end

        def public_domain?(license)
          license == 'cc0'
        end

        def get_copyright(author, license)
          if public_domain?(license)
            "© #{author}, %<year>d. No rights reserved."
          elsif license.nil?
            "© #{author}, %<year>d. All rights reserved."
          else
            "© #{author}, %<year>d. Some rights reserved."
          end
        end

        def get_license_url(license)
          LICENSES[license.to_sym][:url] unless license.nil?
        end

        def get_usage_terms(author, license)
          if public_domain?(license)
            [
              "To the extent possible under law, #{author} has waived all",
              'copyright and related or neighboring rights to this work.'
            ].join(' ')
          elsif !license.nil?
            name = LICENSES[license.to_sym][:name]
            url = LICENSES[license.to_sym][:url]
            [
              "This work is licensed under the Creative Commons #{name} 4.0 International License.",
              "To view a copy of this license, visit #{url} or send a letter to Creative Commons,",
              '171 Second Street, Suite 300, San Francisco, California, 94105, USA.'
            ].join(' ')
          end
        end

        LICENSES = {
          'cc0': { url: 'https://creativecommons.org/publicdomain/zero/1.0/' },
          'cc-by': {
            name: 'Attribution',
            url: 'https://creativecommons.org/licenses/by/4.0/'
          },
          'cc-by-sa': {
            name: 'Attribution-ShareAlike',
            url: 'https://creativecommons.org/licenses/by-sa/4.0/'
          },
          'cc-by-nd': {
            name: 'Attribution-NoDerivatives',
            url: 'https://creativecommons.org/licenses/by-nd/4.0/'
          },
          'cc-by-nc': {
            name: 'Attribution-NonCommercial',
            url: 'https://creativecommons.org/licenses/by-nc/4.0/'
          },
          'cc-by-nc-sa': {
            name: 'Attribution-NonCommercial-ShareAlike',
            url: 'https://creativecommons.org/licenses/by-nc-sa/4.0/'
          },
          'cc-by-nc-nd': {
            name: 'Attribution-NonCommercial-NoDerivatives',
            url: 'https://creativecommons.org/licenses/by-nc-nd/4.0/'
          }
        }.freeze
      end
    end

    def self.load(io)
      Parser.load(io)
    end
  end
end
