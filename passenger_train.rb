require_relative "train.rb"

class PassengerTrain < Train
  def initialize(name)
    super(name)
    @type = :passenger
  end
end
