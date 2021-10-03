require './lib/boat'
require './lib/renter'
require './lib/dock'
require 'rspec'

describe Dock do
  before(:each) do
    @dock = Dock.new("The Rowing Dock", 3)
    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @sup_2 = Boat.new(:standup_paddle_board, 15)
    @canoe = Boat.new(:canoe, 25)
    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

  it 'exists' do
    expect(@dock).to be_a Dock
  end

  it 'has readable attributes' do
    expect(@dock.name).to eq("The Rowing Dock")
    expect(@dock.max_rental_time).to eq(3)
  end

  describe '#rental_log' do
    it 'can return all rented boats and their renters' do
      expect(@dock.rental_log).to eq({})
    end
  end

  describe '#rent' do
    it 'can add an entry to the rental log' do
      @dock.rent(@kayak_1, @patrick)
      @dock.rent(@kayak_2, @patrick)
      @dock.rent(@sup_1, @eugene)
      expected = {
        @kayak_1 => @patrick,
        @kayak_2 => @patrick,
        @sup_1 => @eugene
      }

      expect(@dock.rental_log).to eq(expected)
    end
  end

  describe '#charge' do
    it 'can charge a renter' do
      @dock.rent(@kayak_1, @patrick)
      @dock.rent(@kayak_2, @patrick)
      @dock.rent(@sup_1, @eugene)
      @kayak_1.add_hour
      @kayak_1.add_hour
      expected = {
        :card_number => "4242424242424242",
        :amount => 40
      }

      expect(@dock.charge(@kayak_1)).to eq(expected)
      @sup_1.add_hour
      @sup_1.add_hour
      @sup_1.add_hour
      @sup_1.add_hour
      @sup_1.add_hour
      expected2 ={
        :card_number => "1313131313131313",
        :amount => 45
      }
      expect(@dock.charge(@sup_1)).to eq(expected2)
    end
  end

  describe '#log_hour' do
    it 'can add an hour to all boats in rental log' do
      @dock.rent(@kayak_1, @patrick)
      @dock.rent(@kayak_2, @patrick)
      @dock.log_hour

      @dock.rent(@canoe, @patrick)
      @dock.log_hour

      expect(@kayak_1.hours_rented).to eq(2)
      expect(@canoe.hours_rented).to eq(1)
    end
  end

  describe '#revenue' do
    it 'can return the revenue' do
      expect(@dock.revenue).to eq(0)
    end
  end

  describe '#return' do
    it 'can return a rented boat' do
      @dock.rent(@kayak_1, @patrick)
      @dock.rent(@kayak_2, @patrick)
      @dock.rent(@sup_1, @eugene)

      @dock.return(@kayak_1)
      @dock.return(@kayak_2)
      @dock.return(@sup_1)

      expect(@dock.rental_log).to eq({})
    end

    it 'can add to revenue when boat is returned' do
      @dock.rent(@kayak_1, @patrick)
      @dock.rent(@kayak_2, @patrick)
      @dock.log_hour
      @dock.rent(@canoe, @patrick)
      @dock.log_hour

      @dock.return(@kayak_1)
      @dock.return(@kayak_2)
      @dock.return(@canoe)
      expect(@dock.revenue).to eq(105)
    end

    it 'should not charge past max rental time' do
      @dock.rent(@kayak_1, @patrick)
      @dock.rent(@kayak_2, @patrick)
      @dock.log_hour
      @dock.rent(@canoe, @patrick)
      @dock.log_hour

      @dock.return(@kayak_1)
      @dock.return(@kayak_2)
      @dock.return(@canoe)

      @dock.rent(@sup_1, @eugene)
      @dock.rent(@sup_2, @eugene)
      @dock.log_hour
      @dock.log_hour
      @dock.log_hour
      @dock.log_hour
      @dock.log_hour

      @dock.return(@sup_1)
      @dock.return(@sup_2)

      expect(@dock.revenue).to eq(195)
    end
  end
end