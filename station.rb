# Класс Station (Станция):
#  + Имеет название, которое указывается при ее создании
#  + Может принимать поезда (по одному за раз)
#  + Может возвращать список всех поездов на станции, находящиеся в текущий момент
#  + Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
#  + Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

class Station
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
    @current_train = nil
  end

  def train_arrive(train)
    if available?
      train.stop
      self.current_train = train
      self.trains << train
      self.current_train = nil
    else
      puts "Станция занята другим поездом"
    end
  end

  def train_depart(train)
    trains.delete(train)
  end

  def show_trains
    self.trains.each { |train| puts train.name }
  end

  def show_trains_by_type
    types_count = {}
    self.trains.each { |train| types_count[train.type.name] += 1 }
    types_count.each { |type, count| puts "Поездов типа \"#{type}\": #{count}" }
  end

  private

  def available?
    return self.current_train.nil? ? true : false
  end

end
