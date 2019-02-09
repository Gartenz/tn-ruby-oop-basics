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
# + Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад,
#     но только на 1 станцию за раз.
# + Возвращать предыдущую станцию, текущую, следующую, на основе маршрута

 # + Написать метод, который принимает блок и проходит по всем вагонам поезда 
 #   (вагоны должны быть во внутреннем массиве), передавая каждый объект вагона в блок.
require_relative 'company'
require_relative 'instance_counter'

class Train
  include Company
  include InstanceCounter

  class NameError < StandardError
    def message
      "Непраивльный формат номера поезда. Допустимый формат: "\
      "три буквы или цифры в любом порядке, необязательный дефис "\
      "и еще 2 буквы или цифры после дефиса."
    end
  end

  class WagonError < StandardError
    def message
      "К поезду можно прикрепить вагон того же типа что и позед."
    end
  end

  class MovementError < StandardError
    def message
      "Поезд находится на первой или последней станции."
    end
  end

  attr_accessor :speed
  attr_reader :number, :type, :current_station, :next_station,
   :previous_station, :wagons, :route

  NUMBER_FORMAT = /[а-я\d\w]{3}\-?[а-я\d\w]{2}/i

  @@trains = {}

  def self.find(train_number)
    @@trains[train_number]
  end

  def initialize(train_number, company_name, type = :unknown)
    @speed = 0
    @number = train_number
    @company_name = company_name
    @type = type
    @wagons = []
    @@trains[train_number] = self
    validate!(train_number, company_name)
    self.register_instance
  end

  def add_wagon(wagon)
    validate_wagon!(wagon)
    self.wagons << wagon if stopped?
  end

  def delete_wagon(number)
    self.wagons.delete_at(number) if stopped? && self.wagons.any?
  end

  def stop
    self.speed = 0
  end

  def route=(route)
    @route = route
    @current_station = route.stations.first
    self.route.stations.first.train_arrive(self)
  end

  def each_wagon(&block)
    if block_given?
      self.wagons.each { |wagon| yield wagon }
    else
      raise ArgumentError
    end
  end

  def each_wagon_with_index(position, &block)
    if block_given?
      self.wagons.each.with_index(position) { |wagon, index| yield wagon, index }
    else
      raise ArgumentError
    end
  end

  def move_forward
    return unless has_route? 
    raise MovementError if self.current_station == self.route.stations.last
    @previous_station = @current_station
    self.current_station.train_depart(self)
    self.speed += 10
    next_station_index = self.route.stations.index(self.current_station) + 1
    @next_station = self.route.stations[next_station_index]
    self.next_station.train_arrive(self)
  end

  def move_backward
    return unless has_route?
    raise MovementError if self.current_station == self.route.stations.first
    @previous_station = @current_station
    self.current_station.train_depart(self)
    self.speed += 10
    next_station_index = self.route.index(self.current_station) - 1
    @next_station = self.route.stations[next_station_index]
    self.next_station.train_arrive(self)
  end

  def stopped?
    self.speed.zero?
  end

  def valid?
    validate!(self.number, self.company_name)
    true
  rescue NameError,CompanyNameError
    false
  end

  protected

  def validate!(train_number, company_name)
    raise NameError unless train_number =~ NUMBER_FORMAT
    validate_company_name!(company_name)
  end

  private

  def has_route?
    self.route != nil
  end

  def validate_wagon!(wagon)
    raise WagonError unless self.type == wagon.type
  end

end
