class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Exception do |exception|
    flash! alert: "Access Denied"
    render nothing: true
  end
end
