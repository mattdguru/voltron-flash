module Voltron
  module Flash
    class Engine < Rails::Engine

      isolate_namespace Voltron

      initializer 'voltron.flash.initialize' do
        ::ActionController::Base.send :prepend, ::Voltron::Flash
        ::ActionController::Base.send :helper, ::Voltron::FlashHelper
      end

    end
  end
end
