require_relative 'wagon'

class CagroWagon < Wagon
  def initialize
    @type = :cargo
  end
end
