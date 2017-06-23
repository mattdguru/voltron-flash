module Voltron
  module Flash
    module Generators
      class InstallGenerator < Rails::Generators::Base

        source_root File.expand_path('../../../../../../', __FILE__)

        desc 'Add Voltron Flash initializer'

        def inject_initializer

          voltron_initialzer_path = Rails.root.join('config', 'initializers', 'voltron.rb')

          unless File.exist? voltron_initialzer_path
            unless system("cd #{Rails.root.to_s} && rails generate voltron:install")
              puts 'Voltron initializer does not exist. Please ensure you have the \'voltron\' gem installed and run `rails g voltron:install` to create it'
              return false
            end
          end

          current_initiailzer = File.read voltron_initialzer_path

          unless current_initiailzer.match(Regexp.new(/# === Voltron Flash Configuration ===/))
            inject_into_file(voltron_initialzer_path, after: "Voltron.setup do |config|\n") do
<<-CONTENT

  # === Voltron Flash Configuration ===

  # What http header the flash messages should be added to on ajax responses
  config.flash.header = "X-Flash"

  # Whether to group flash messages by type, or give each flash message it's own line, complete with close icon
  config.flash.group = true
CONTENT
            end
          end
        end
      end
    end
  end
end