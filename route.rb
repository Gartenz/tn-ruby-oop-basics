# Класс Route (Маршрут):
# + Имеет начальную и конечную станцию, а также список промежуточных станций.
#     Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
# + Может добавлять промежуточную станцию в список
# + Может удалять промежуточную станцию из списка
# + Может выводить список всех станций по-порядку от начальной до конечной
require_relative 'instance_counter'

class Route
  include InstanceCounter
  
  class AddStationError < StandardError
    def message
      "Невозможно добавить станцию. Такая станция уже существует в маршруте."
    end
  end

  class DeleteStationError < StandardError
    def message
      "Невозможно удалить станцию. Эта станция первая/последняя в маршруте."
    end
  end

  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = []
    @stations << first_station << last_station
  end

  def add_station(station)
    raise AddStationError if self.stations.include?(station)
    self.stations.insert(-2, station)
  end

  def delete_station(station)
    return unless self.stations.include?(station)
    raise DeleteStationError if [self.stations.first, self.stations.last].include?(station)
    self.stations.delete(station)
  end
  
  def to_s
    route_map = ""
    self.stations.each do |station|
      route_map += self.stations.last != station ? "#{station.name} -> " : "#{station.name}"
    end
    route_map
  end
end
