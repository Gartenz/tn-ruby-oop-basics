require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize(company_name, space)
    super(company_name, space)
    @type = :passenger
  end

  def take_seat
    raise FreeSpaceError if free_space.zero?

    self.occupied_space += 1
    self.free_space -= 1
  end
end
