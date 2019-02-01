require_relative 'train'

class CargoTrain < Train
  def initialize
    @type = :cargo
  end
end
