# Класс Route (Маршрут):
# + Имеет начальную и конечную станцию, а также список промежуточных станций.
#     Начальная и конечная станции указываютсся при создании маршрута, а промежуточные могут добавляться между ними.
# + Может добавлять промежуточную станцию в список
# + Может удалять промежуточную станцию из списка
# + Может выводить список всех станций по-порядку от начальной до конечной

class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = []
    @stations << first_station << last_station
  end

  def add_station(station)
    return if self.stations.include?(station)
    self.stations.insert(-2, station)
    puts "Станция добавлена."
  end

  def delete_station(station)
    return unless self.stations.include?(station)
    return if [self.stations.first, self.stations.last].include?(station)
    self.stations.delete(station)
    puts "Станция удалена."
  end

  def show
    route_map = ""
    self.stations.each do |station| 
      route_map += self.stations.last != station ? "#{station.name} -> " : "#{station.name}"
    end
    puts route_map
  end

  def to_s
    route_map = ""
    self.stations.each do |station|
      route_map += self.stations.last != station ? "#{station.name} -> " : "#{station.name}"
    end
    route_map
  end
end
