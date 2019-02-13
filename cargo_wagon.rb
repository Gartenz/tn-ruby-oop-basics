require_relative 'wagon'

class CargoWagon < Wagon
  def initialize(company_name, space)
    super(company_name, space)
    @type = :cargo
  end

  def add_cargo(space)
    raise FreeSpaceError if free_space < space

    self.occupied_space += space
    self.free_space -= space
  end
end
