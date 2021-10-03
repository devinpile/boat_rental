require './lib/renter.rb'

RSpec.describe Renter do
  before(:each) do
    @renter = Renter.new("Patrick Star", "4242424242424242")
  end

  it 'renter name' do
    expect(@renter.name).to eq("Patrick Star")
  end

  it 'credit card number' do
    expect(@renter.credit_card_number).to eq("4242424242424242")
  end
end