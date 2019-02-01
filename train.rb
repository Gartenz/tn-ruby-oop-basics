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

class Train
  attr_accessor :speed
  attr_reader :name, :type, :current_station, :next_station, :previous_station, :wagons

  def initialize(name, type)
    @speed = 0
    @name = name
    @type = type
    @wagons = []
  end

  def add_wagon(wagon)
    if stopped? && to_hook?(wagon)
      self.wagons << wagon
    else
      puts "Нельзя добавить вагон."
    end
  end

  def delete_wagon(wagon)
    if stopped? && self.wagons.any? && to_hook?(wagon)
      self.wagons.delete(wagon)
    else 
      puts "Нельзя оцепить вагон."
    end
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
      self.previous_station = @current_station
      self.current_station.train_depart(self)
      self.speed += 10
      next_station_index = self.route.index(self.current_station) + 1
      self.next_station = self.route.stations[next_station_index]
    else
      puts "Поезд на последней станции"
    end
  end

  def move_backward
    if self.current_station != self.route.stations.first
      self.previous_station = @current_station
      self.current_station.train_depart(self)
      self.speed += 10
      previous_station_index = self.route.index(self.current_station) - 1
      self.next_station = self.route.stations[previous_station_index]
    else
      puts "Поезд на первой станции"
    end
  end

  def stopped?
    self.speed.zero?
  end

  private

  def to_hook?(wagon)
    self.type == wagon.type
  end

end
