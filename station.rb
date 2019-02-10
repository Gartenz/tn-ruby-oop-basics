# Класс Station (Станция):
#  + Имеет название, которое указывается при ее создании
#  + Может принимать поезда (по одному за раз)
#  + Может возвращать список всех поездов на станции, находящиеся в текущий момент
#  + Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
#  + Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

# написать метод, который принимает блок и проходит по всем поездам на станции, передавая каждый поезд в блок.

require_relative 'instance_counter'

class Station
  include InstanceCounter
  
  class NameError < StandardError
    def message
      "Неправильный формат стании. Имя станции может содержать только буквы и числа."
    end
  end

  class UniquenessError < StandardError
    def message
      "Станция с таким именем уже существует."
    end
  end

  attr_reader :name, :trains

  STATION_NAME_FORMAT = /[а-я\w\d]*/

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
    self.trains << train
  end

  def train_depart(train)
    self.trains.delete(train)
  end

  def list_trains
    return unless self.trains
    list = ""
    self.trains.each { |train| list += "\"#{train.number}\" тип: #{train.type} кол-во вагонов: #{train.wagons.count}" }
    list
  end

  def list_trains_by_type
    return unless self.trains
    types_count = {}
    self.trains.each { |train| types_count[train.type.name] += 1 }
    list = ""
    types_count.each { |type, count| list "Поездов типа \"#{type}\": #{count}" }
    list
  end
  
  def each_train(&block)
    self.trains.each { |train| yield train }
  end

  def each_train_with_index(position, &block)
    self.trains.each.with_index(position) { |train, index| yield train, index }
  end
  protected

  def validate!(name)
    raise NameError unless name =~ STATION_NAME_FORMAT
    raise UniquenessError if Station.find(name)
  end 

  private

  @@stations = {}
end
