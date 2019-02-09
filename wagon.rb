require_relative 'company'

class Wagon
  include Company

  class FreeSpaceError < StandardError
    def message
      "В вагоне больше нет свободного места."
    end
  end

  attr_reader :type, :total_space, :occupied_space, :free_space

  def initialize(company_name, space, type = :unknown)
    @company_name = company_name
    @type = type
    @total_space = @free_space = space
    @occupied_space = 0
    validate_company_name!(company_name)
  end

  protected 
  
  attr_writer :occupied_space, :free_space
end
