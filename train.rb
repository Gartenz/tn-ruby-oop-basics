# Класс Train (Поезд):
# + Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов,
#     эти данные указываются при создании экземпляра класса
# + Может набирать скорость
# + Может возвращать текущую скорость
# + Может тормозить (сбрасывать скорость до нуля)
# + Может возвращать количество вагонов
# + Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов). 
#     Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
# + Может принимать маршрут следования (объект класса Route). 
# + При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
# + Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
# + Возвращать предыдущую станцию, текущую, следующую, на основе маршрута


class TrainTypes
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Train
  attr_accessor :speed
  attr_reader :cart_count, :type, :current_station, :next_station, :previos_station

  def initialize(name, type, cart_count)
    @speed = 0
    @name = name
    @type = type
    @cart_count = cart_count
  end

  def add_cart
    self.cart_count += 1 if stopped?
  end

  def delete_cart
    self.cart_count -= 1 if stopped? && cart_count > 0
  end

  def stop
    self.speed = 0
  end

  def route=(route)
    self.route = route
    self.current_station = route.stations.first
    self.route.stations.first.train_arrive(self)
  end

  def move_forward
    if self.current_station != self.route.stations.last
      self.previos_station = @current_station
      self.current_station.train_depart(self)
      self.speed += 10
      next_station_index = self.route.index(self.current_station) + 1
      self.next_station = self.route.stations[next_station_index]
    else
      puts "Поезд на последней станции"
  end

  def move_backward
    if self.current_station != self.route.stations.first
      self.previos_station = @current_station
      self.current_station.train_depart(self)
      self.speed += 10
      previous_station_index = self.route.index(self.current_station) - 1
      self.next_station = self.route.stations[previous_station_index]
    else
      puts "Поезд на первой станции"
  end

  def stopped?
    self.speed.zero?
  end

end
