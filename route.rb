require_relative 'instance_counter'
require_relative 'accessor'

class Route
  include InstanceCounter
  include Accessors

  class AddStationError < StandardError
    def message
      'Невозможно добавить станцию. Такая станция уже существует в маршруте.'
    end
  end

  class DeleteStationError < StandardError
    def message
      'Невозможно удалить станцию. Эта станция первая/последняя в маршруте.'
    end
  end

  strong_attr_accessor stations: Array

  def initialize(first_station, last_station)
    @stations = []
    @stations << first_station << last_station
  end

  def add_station(station)
    raise AddStationError if stations.include?(station)

    stations.insert(-2, station)
  end

  def delete_station(station)
    return unless stations.include?(station)
    raise DeleteStationError if [stations.first, stations.last].include?(station)

    stations.delete(station)
  end

  def to_s
    route_map = ''
    stations.each do |station|
      route_map += stations.last != station ? "#{station.name} -> " : station.name
    end
    route_map
  end
end
