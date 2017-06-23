class TestController < ActionController::Base
  def index
    flash! notice: 'Test'
    head :ok
  end

  def page
    flash! notice: 'Test Render'
    render plain: 'Blank'
  end

  def redirect
    flash! alert: 'Redirect Flash'
    redirect_to '/page'
  end
end