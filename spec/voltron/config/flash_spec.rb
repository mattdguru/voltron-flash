require "rails_helper"

describe Voltron::Config::Flash do

  let(:flash) { Voltron::Config::Flash.new }

  it "should have a default header of X-Flash" do
    expect(flash.header).to eq("X-Flash")
  end

  it "should return an instance of the flash config" do
    expect(Voltron.config.flash).to be_a(Voltron::Config::Flash)
  end

  it "includes flash config in voltron config when generated" do
    expect(Voltron.config.to_h).to have_key(:flash)
    expect(Voltron.config.to_h[:flash]).to eq({ header: "X-Flash", group: true })
  end
end
