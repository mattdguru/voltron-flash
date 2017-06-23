module Voltron
  module FlashHelper

    def voltron_flashes(*classes)
      render template: 'voltron/flash/flashes', locals: { container_class: classes.flatten.compact.join(' ') }
    end

    alias_method :flashes, :voltron_flashes

  end
end
