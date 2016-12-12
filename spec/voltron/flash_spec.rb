require "rails_helper"

class TestController < ActionController::Base
  def index
    flash! notice: "Test"
    head :ok
  end

  def page
    flash! notice: "Test Render"
    render text: "Blank"
  end

  def redirect
    flash! alert: "Redirect Flash"
    redirect_to '/page'
  end
end

describe TestController, type: :controller do

  let(:controller) { TestController.new }

  it "has a version number" do
    expect(Voltron::Flash::VERSION).not_to be nil
  end

  it "can add flashes" do
    expect(controller.instance_variable_get("@stored_flashes")).to be_blank

    controller.flash! notice: "Test"

    expect(controller.instance_variable_get("@stored_flashes")).to eq({ notice: ["Test"] })
  end

  it "has flashes in the response headers" do
    get :index, xhr: true

    flashes = JSON.parse(response.headers["X-Flash"])

    expect(flashes).to eq({ "notice" => ["Test"] })
  end

  it "should not include flash response header if not an ajax request" do
    get :index
    expect(response.headers).to_not have_key("X-Flash")

    get :index, xhr: true
    expect(response.headers).to have_key("X-Flash")
  end

  it "adds flashes to flash.now if rendering" do
    get :page
    expect(flash[:notice]).to eq(["Test Render"])
  end

  it "adds flash messages when redirecting" do
    get :redirect
    expect(flash[:alert]).to eq(["Redirect Flash"])
  end

end
