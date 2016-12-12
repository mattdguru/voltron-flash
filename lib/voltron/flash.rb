require "voltron"
require "voltron/flash/version"
require "voltron/config/flash"

module Voltron
  module Flash

    def self.prepended(base)
      base.send :after_action, :include_flash_later
    end

    def render(*args)
      include_flash_now
      super *args
    end

    def flash!(**flashes)
      flashes.symbolize_keys.each do |type,messages|
        stored_flashes[type] ||= []
        stored_flashes[type] += Array.wrap(messages)
      end
    end

    private

      def stored_flashes
        @stored_flashes ||= {}
      end

      # Before rendering, include any flash messages in flash.now,
      # so they will be available when the page is rendered
      def include_flash_now
        if !request.xhr?
          stored_flashes.each { |type,messages| flash.now[type] = messages }
        end
      end

      # If request is an ajax request, or we are redirecting, include flash messages
      # in the appropriate outlet, either response headers or `flash` itself
      def include_flash_later
        if request.xhr?
          response.headers[Voltron.config.flash.header] = stored_flashes.to_json
        elsif is_redirecting?
          stored_flashes.each { |type,messages| flash[type] = messages }
        end
      end

      def is_redirecting?
        self.status == 302 || self.status == 301
      end

  end
end

require "voltron/flash/engine" if defined?(Rails)