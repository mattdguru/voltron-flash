class HomeController < ApplicationController

  def index
    flash! warning: "Test"
  end

  def redirect
    flash! notice: "You've been redirected"
    redirect_to landing_path
  end

  def landing
  end

  def ajax
    flash! warning: "Oh noes"
    head :ok
  end

end