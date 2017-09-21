module Voltron
  module Flash
    module Generators
      module Install
        class ViewsGenerator < Rails::Generators::Base

          source_root File.expand_path('../../../../../../', __FILE__)

          desc 'Install Voltron Flash views'

          def copy_views
            copy_file 'app/views/voltron/flash/flashes.html.erb', Rails.root.join('app', 'views', 'voltron', 'flash', 'flashes.html.erb')
          end

        end
      end
    end
  end
end