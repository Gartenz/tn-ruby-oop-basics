require_relative 'instance_counter'
require_relative 'accessor'
require_relative 'validation'

class Station
  include InstanceCounter
  include Accessors
  include Validation

  class NameError < StandardError
    def message
      'Неправильный формат стании. Имя станции может содержать только буквы и числа.'
    end
  end

  class UniquenessError < StandardError
    def message
      'Станция с таким именем уже существует.'
    end
  end

  attr_reader :trains
  strong_attr_accessor name: String

  validate :name, :format, /[а-я\w\d]*/

  # rubocop:disable Style/ClassVars
  @@stations = {}

  def self.all
    @@stations
  end

  def self.find(name)
    @@stations[name]
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations[name] = self
    validate!
    validate_uniqueness!(name)
  end

  def train_arrive(train)
    train.stop
    trains << train
  end

  def train_depart(train)
    trains.delete(train)
  end

  def list_trains
    return unless trains

    list = ''
    trains.each do |train|
      list += "\"#{train.number}\" тип: #{train.type} вагонов: #{train.wagons.count}\n"
    end
    list
  end

  def list_trains_by_type
    return unless trains

    types_count = {}
    trains.each { |train| types_count[train.type.name] += 1 }
    list = ''
    types_count.each { |type, count| list "Поездов типа \"#{type}\": #{count}\n" }
    list
  end

  def each_train
    trains.each { |train| yield train }
  end

  def each_train_with_index(position)
    trains.each.with_index(position) { |train, index| yield train, index }
  end

  protected

  def validate_uniqueness!(name)
    raise UniquenessError if Station.find(name)
  end
end

# rubocop:enable Style/ClassVars
