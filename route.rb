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
    self.stations.insert(-2, station)
  end

  def delete_station(station)
    return unless self.stations.include?(station)
    return if [self.stations.first, self.stations.last].include?(station)
    self.stations.delete(station)
  end

  def show
    self.stations.each { |station| puts station.name }
  end
end
