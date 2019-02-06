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
require_relative 'company'
require_relative 'instance_counter'

class Train
  include Company
  include InstanceCounter

  attr_accessor :speed
  attr_reader :train_number, :type, :current_station, :next_station,
   :previous_station, :wagons, :route

  @@trains = []

  def self.find(train_number)
    @@trains.each { |train| return train if train.train_number.downcase == train_number.downcase }
    nil
  end

  def initialize(train_number, company_name, type = :unknown)
    @speed = 0
    @train_number = train_number
    @company_name = company_name
    @type = type
    @wagons = []
    @@trains << self
    self.register_instance
  end

  def add_wagon(wagon)
    if stopped? && to_hook?(wagon)
      self.wagons << wagon
    else
      puts "Нельзя добавить вагон."
    end
  end

  def delete_wagon(number)
    if stopped? && self.wagons.any?
      self.wagons.delete_at(number)
    else 
      puts "Нельзя оцепить вагон."
    end
  end

  def stop
    self.speed = 0
  end

  def route=(route)
    @route = route
    @current_station = route.stations.first
    self.route.stations.first.train_arrive(self)
  end

  def list_wagons
    puts "Количество вагоно у поезда \"#{self.train_number}\": #{self.wagons.size}"
    self.wagons.each_with_index { |wagon,index| puts "#{index}.#{wagon}" }
  end

  def move_forward
    return unless has_route? 
    if self.current_station != self.route.stations.last
      @previous_station = @current_station
      self.current_station.train_depart(self)
      self.speed += 10
      next_station_index = self.route.stations.index(self.current_station) + 1
      @next_station = self.route.stations[next_station_index]
      puts "Поезд отправляется на станцию: #{self.next_station.name}"
      self.next_station.train_arrive(self)
    else
      puts "Поезд на последней станции"
    end
  end

  def move_backward
    return unless has_route?
    if self.current_station != self.route.stations.first
      @previous_station = @current_station
      self.current_station.train_depart(self)
      self.speed += 10
      next_station_index = self.route.index(self.current_station) - 1
      @next_station = self.route.stations[next_station_index]
      puts "Поезд отправляется на станцию: #{self.next_station}"
      self.next_station.train_arrive(self)
    else
      puts "Поезд на первой станции"
    end
  end

  def stopped?
    self.speed.zero?
  end

  private

  def has_route?
    self.route != nil
  end

  def to_hook?(wagon)
    self.type == wagon.type
  end

end
