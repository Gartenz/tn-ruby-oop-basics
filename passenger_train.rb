require_relative "train.rb"

class PassengerTrain < Train
  def initialize
    @type = :passenger
  end
end
