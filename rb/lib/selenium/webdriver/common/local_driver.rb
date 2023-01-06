# frozen_string_literal: true

module Selenium
  module WebDriver
    module LocalDriver
      def initialize_local_driver(capabilities, options, service, url)
        raise ArgumentError, "Can't initialize #{self.class} with :url" if url

        caps = process_options(options, capabilities)
        service ||= Service.send(browser)
        url = service_url(service)

        [caps, url]
      end

      def process_options(options, capabilities)
        default_options = Options.send(browser)

        if options && capabilities
          msg = "Don't use both :options and :capabilities when initializing #{self.class}, prefer :options"
          raise ArgumentError, msg
        elsif options && !options.is_a?(default_options.class)
          raise ArgumentError, ":options must be an instance of #{default_options.class}"
        elsif capabilities
          WebDriver.logger.deprecate("The :capabilities parameter for #{self.class}",
                                     ":options argument with an instance of #{self.class}",
                                     id: :capabilities)
          generate_capabilities(capabilities)
        else
          (options || default_options).as_json
        end
      end
    end
  end
end
