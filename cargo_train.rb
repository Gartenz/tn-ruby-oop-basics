require_relative 'train'

class CargoTrain < Train
  def initialize(train_number, company_name)
    super(train_number, company_name)
    @type = :cargo
  end
end
