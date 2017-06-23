require 'spec_helper'

describe ActionView::Base, type: :helper do

  include Voltron::FlashHelper

  it 'outputs flash markup' do
    flash[:notice] = ['Test']
    expect(flashes).to match(/<div id="flashes" class="">.*/)
  end

end