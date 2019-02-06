require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize(company_name)
    super(company_name)
    @type = :passenger
  end
end
