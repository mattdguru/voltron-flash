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
        stored_flashes[type] << { ajax: flashes.delete(:ajax), messages: Array.wrap(messages) }
      end
    end

    private

      def stored_flashes
        @stored_flashes ||= {}
      end

      # Before rendering, include any flash messages in flash.now,
      # so they will be available when the page is rendered
      def include_flash_now
        flash_hash(true).each { |type,messages| flash.now[type] = messages }
      end

      # If request is an ajax request, or we are redirecting, include flash messages
      # in the appropriate outlet, either response headers or `flash` itself
      def include_flash_later
        if is_redirecting?
          flash_hash.each { |type,messages| flash[type] = messages }
        else
          response.headers[Voltron.config.flash.header] = flash_hash.to_json
        end
      end

      def is_redirecting?
        self.status == 302 || self.status == 301
      end

      def flash_hash(rendering=false)
        flashes = stored_flashes.map do |type,messages|
          { type => messages.map do |f|
              f[:messages] if !(f[:ajax] == false && request.xhr?) || (f[:ajax] == false && request.xhr? && rendering)
            end.compact.flatten
          }
        end
        flashes.reduce(Hash.new, :merge).reject { |k,v| v.blank? || k == :ajax }
      end

  end
end

require "voltron/flash/engine" if defined?(Rails)