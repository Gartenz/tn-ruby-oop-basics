require_relative 'company'
require_relative 'validation'

class Wagon
  include Company

  class FreeSpaceError < StandardError
    def message
      'В вагоне больше нет свободного места.'
    end
  end

  attr_reader :type, :total_space, :occupied_space, :free_space

  validate :company_name, :presence

  def initialize(company_name, space, type = :unknown)
    @company_name = company_name
    @type = type
    @total_space = @free_space = space
    @occupied_space = 0
    valid?
  end

  protected

  attr_writer :occupied_space, :free_space
end
