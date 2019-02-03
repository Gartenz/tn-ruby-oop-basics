# Класс Station (Станция):
#  + Имеет название, которое указывается при ее создании
#  + Может принимать поезда (по одному за раз)
#  + Может возвращать список всех поездов на станции, находящиеся в текущий момент
#  + Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
#  + Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def train_arrive(train)
    train.stop
    self.trains << train
  end

  def train_depart(train)
    self.trains.delete(train)
  end

  def list_trains
    return if self.trains.nil?
    self.trains.each { |train| puts "\"#{train.name}\" тип: #{train.type}" }
  end

  def list_trains_by_type
    return if self.trains.nil?
    types_count = {}
    self.trains.each { |train| types_count[train.type.name] += 1 }
    types_count.each { |type, count| puts "Поездов типа \"#{type}\": #{count}" }
  end
end
