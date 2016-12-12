module Voltron
  module Flash
    class Engine < Rails::Engine

      isolate_namespace Voltron

      config.autoload_paths += Dir["#{config.root}/lib/**/"]

      initializer "voltron.flash.initialize" do
        ::ActionController::Base.send :prepend, ::Voltron::Flash
        ::ActionController::Base.send :helper, ::Voltron::FlashHelper
      end

    end
  end
end
