require_relative "train.rb"

class PassengerTrain < Train
  def initialize(train_number, company_name)
    super(train_number, company_name)
    @type = :passenger
  end
end
