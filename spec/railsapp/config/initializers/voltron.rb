Voltron.setup do |config|

  # === Voltron Base Configuration ===

  # Whether to enable debug output in the browser console and terminal window
  config.debug = true

  # The base url of the site. Used by various voltron-* gems to correctly build urls
  # config.base_url = "http://localhost:3000"

  # What logger calls to Voltron.log should use
  # config.logger = Logger.new(Rails.root.join("log", "voltron.log"))

  # What http header the flash messages should be added to on ajax responses
  config.flash.header = 'X-Flash'

  # Whether to group flash messages by type, or give each flash message it's own line, complete with close icon
  config.flash.group = true

end