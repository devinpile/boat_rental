class Dock
  attr_reader :name,
              :max_rental_time,
              :rental_log,
              :revenue

  def initialize(name, max_rental_time)
    @name            = name
    @max_rental_time = max_rental_time
    @rental_log      = {}
    @revenue         = 0
  end

  def rent(boat, renter)
    @rental_log[boat] = renter
  end

  def charge(boat)
    hash = @rental_log.select do |rented_boat, renter|
      rented_boat == boat
    end
      {
        :card_number => hash.values[0].credit_card_number,
        :amount => hash.keys[0].price_per_hour * hash.keys[0].hours_rented
      }
  end

  def log_hour
    @rental_log.map do |boat, renter|
      boat.add_hour
    end
  end

  def revenue
    @revenue
  end

  def return(boat)
    rental_log.delete(boat)
    @revenue += boat.price_per_hour * boat.hours_rented
  end
end