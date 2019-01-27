# Класс Route (Маршрут):
# + Имеет начальную и конечную станцию, а также список промежуточных станций.
#     Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
# + Может добавлять промежуточную станцию в список
# + Может удалять промежуточную станцию из списка
# + Может выводить список всех станций по-порядку от начальной до конечной

class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations << first_station << last_station
  end

  def add_station(station)
    stations_len = self.stations.size
    self.stations.insert(stations_len - 1, station)
  end

  def delele_station(station)
    if self.stations.include?(station)
      position = self.stations.index(station)
      self.stations.delete_at(position)
    end
  end

  def show
    self.stations.each { |station| puts station.name }
  end
end
