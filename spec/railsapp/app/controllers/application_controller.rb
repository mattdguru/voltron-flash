class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Exception do |exception|
    flash! alert: 'Access Denied'
    head :ok
  end
end
