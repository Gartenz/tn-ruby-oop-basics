require_relative 'company'
require_relative 'instance_counter'

class Train
  include Company
  include InstanceCounter

  class NameError < StandardError
    def message
      'Непраивльный формат номера поезда. Допустимый формат: '\
      'три буквы или цифры в любом порядке, необязательный дефис '\
      'и еще 2 буквы или цифры после дефиса.'
    end
  end

  class WagonError < StandardError
    def message
      'К поезду можно прикрепить вагон того же типа что и позед.'
    end
  end

  class MovementError < StandardError
    def message
      'Поезд находится на первой или последней станции.'
    end
  end

  attr_accessor :speed
  attr_reader :number, :type, :current_station, :wagons, :route

  NUMBER_FORMAT = /[а-я\d\w]{3}\-?[а-я\d\w]{2}/i.freeze

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
    register_instance
  end

  def add_wagon(wagon)
    validate_wagon!(wagon)
    wagons << wagon if stopped?
  end

  def delete_wagon(number)
    wagons.delete_at(number) if stopped? && wagons.any?
  end

  def stop
    self.speed = 0
  end

  def route=(route)
    @route = route
    @current_station = route.stations.first
    self.route.stations.first.train_arrive(self)
  end

  def each_wagon
    wagons.each { |wagon| yield wagon }
  end

  def each_wagon_with_index(position)
    wagons.each.with_index(position) { |wagon, index| yield wagon, index }
  end

  def next_station
    raise MovementError if current_station == route.stations.last

    next_station_index = route.stations.index(current_station) + 1
    route.stations[next_station_index]
  end

  def previous_station
    raise MovementError if current_station == route.stations.first

    next_station_index = route.stations.index(current_station) - 1
    route.stations[next_station_index]
  end

  def move_forward
    return unless route?
    raise MovementError if current_station == route.stations.last

    current_station.train_depart(self)
    self.speed += 10
    next_station.train_arrive(self)
  end

  def move_backward
    return unless route?
    raise MovementError if current_station == route.stations.first

    current_station.train_depart(self)
    self.speed += 10
    previous_station.train_arrive(self)
  end

  def stopped?
    self.speed.zero?
  end

  def valid?
    validate!(number, company_name)
    true
  rescue NameError, CompanyNameError
    false
  end

  protected

  def validate!(train_number, company_name)
    raise NameError unless train_number =~ NUMBER_FORMAT

    validate_company_name!(company_name)
  end

  private

  def route?
    route != nil
  end

  def validate_wagon!(wagon)
    raise WagonError unless type == wagon.type
  end
end
