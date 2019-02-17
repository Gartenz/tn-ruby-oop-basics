require_relative 'company'
require_relative 'instance_counter'
require_relative 'accessor'
require_relative 'validation'

class Train
  include Company
  include InstanceCounter
  include Accessors
  include Validation

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

  strong_attr_accessor speed: Integer
  attr_reader :type, :current_station, :wagons, :route
  attr_accessor_with_history :number

  validate :number, :presence
  validate :number, :format, /[а-я\d\w]{3}\-?[а-я\d\w]{2}/i
  validate :company_name, :presence

  # rubocop:disable Style/ClassVars
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
    valid?
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

  private

  def route?
    route != nil
  end

  def validate_wagon!(wagon)
    raise WagonError unless type == wagon.type
  end
end

# rubocop:enable Style/ClassVars
