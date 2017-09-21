module Voltron
  module Flash
    module Generators
      module Install
        class AssetsGenerator < Rails::Generators::Base

          source_root File.expand_path('../../../../../../', __FILE__)

          desc 'Install Voltron Flash assets'

          def copy_javascripts_assets
            copy_file 'app/assets/javascripts/voltron-flash.js', Rails.root.join('app', 'assets', 'javascripts', 'voltron-flash.js')
          end

          def copy_stylesheets_assets
            copy_file 'app/assets/stylesheets/voltron-flash.scss', Rails.root.join('app', 'assets', 'stylesheets', 'voltron-flash.scss')
          end

        end
      end
    end
  end
end