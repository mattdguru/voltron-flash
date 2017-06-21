require 'voltron'
require 'voltron/flash/version'
require 'voltron/config/flash'

module Voltron
  module Flash

    def self.prepended(base)
      base.send :after_action, :include_flash_later
    end

    def render(*args)
      include_flash_now
      super
    end

    def redirect_to(options={}, response_status={})
      include_flash_later
      super
    end

    def flash!(**flashes)
      flashes.symbolize_keys.each do |type,messages|
        stored_flashes[type] ||= []
        stored_flashes[type] += Array.wrap(messages)
      end

      # Set the headers initially. If redirecting, they will be removed as the flash will instead be a part of `flash`
      response.headers[Voltron.config.flash.header] = stored_flashes.to_json
    end

    private

      def stored_flashes
        @stored_flashes ||= {}
      end

      # Before rendering, include any flash messages in flash.now,
      # so they will be available when the page is rendered
      def include_flash_now
        stored_flashes.each { |type,messages| flash.now[type] = messages }
      end

      # When redirecting, remove the flash from the headers (unless ajax request), append it all to the `flash` object
      def include_flash_later
        unless request.xhr?
          response.headers.except! Voltron.config.flash.header
          stored_flashes.each { |type,messages| flash[type] = messages }
        end
      end

  end
end

require 'voltron/flash/engine' if defined?(Rails)