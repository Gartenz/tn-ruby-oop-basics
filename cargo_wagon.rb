require_relative 'wagon'

class CargoWagon < Wagon
  def initialize(company_name)
    super(company_name)
    @type = :cargo
  end
end
