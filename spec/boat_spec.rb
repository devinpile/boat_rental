require './lib/boat'
require './lib/renter'
require 'rspec'

describe Boat do
  before(:each) do
    @kayak = Boat.new(:kayak, 20)
  end

  it 'exists' do
    expect(@kayak).to be_a Boat
  end

  it 'has readable attributes' do
    expect(@kayak.type).to eq(:kayak)
    expect(@kayak.price_per_hour).to eq(20)
    expect(@kayak.hours_rented).to eq(0)
  end

  describe '#add_hour' do
    it 'can add an hour' do
      @kayak.add_hour
      @kayak.add_hour
      @kayak.add_hour

      expect(@kayak.hours_rented).to eq(3)
    end
  end
end