require_relative 'instance_counter'

class Station
  include InstanceCounter

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

  attr_reader :name, :trains

  # rubocop:disable Style/ClassVars
  @@stations = {}

  STATION_NAME_FORMAT = /[а-я\w\d]*/.freeze

  def self.all
    @@stations
  end

  def self.find(name)
    @@stations[name]
  end

  def initialize(name)
    validate!(name)
    @name = name
    @trains = []
    @@stations[name] = self
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

  def validate!(name)
    raise NameError unless name =~ STATION_NAME_FORMAT
    raise UniquenessError if Station.find(name)
  end
end

# rubocop:enable Style/ClassVars
