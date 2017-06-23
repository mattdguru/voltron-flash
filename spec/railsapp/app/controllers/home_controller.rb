class HomeController < ApplicationController

  def index
    flash! warning: 'This flash message was set in flash.now automatically. Wait 3 seconds for ajax...'
  end

  def redirect
    flash! alert: 'This flash message was set on the previous page. Wait 3 seconds for ajax...'
    redirect_to landing_path
  end

  def landing
  end

  def ajax
    flash! warning: 'This came from an ajax request, check the headers'
    head :ok
  end

  def error
    raise Exception.new('Exception')
  end

end
