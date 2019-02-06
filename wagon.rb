require_relative 'company'

class Wagon
  include Company

  attr_reader :type

  def initialize(company_name, type = :unknown)
    @company_name = company_name
    @type = type
  end
end
