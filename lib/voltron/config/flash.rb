require "active_support"

module Voltron
  class Config

    include ::ActiveSupport::Callbacks

    set_callback :generate_voltron_config, :add_flash_config

    def flash
      @flash ||= Flash.new
    end

    def add_flash_config
      Voltron.config.merge(flash: flash.to_h)
    end

    class Flash

      attr_accessor :header, :group

      def initialize
        @header ||= 'X-Flash'
        @group = true unless @group === false
      end

      def to_h
        { header: header, group: group }
      end
    end

  end
end