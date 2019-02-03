class Wagon
  attr_reader :type

  def initialize(type = :unknown)
    @type = type
  end
end
