#  Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
#      - Создавать станции
#      - Создавать поезда
#      - Создавать маршруты и управлять станциями в нем (добавлять, удалять)
#      - Назначать маршрут поезду
#      - Добавлять вагоны к поезду
#      - Отцеплять вагоны от поезда
#      - Перемещать поезд по маршруту вперед и назад
#      - Просматривать список станций и список поездов на станции

require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'

class ControlPanel
  attr_reader :trains, :routes, :stations

  def initialize
    @trains = []
    @routes = []
    @stations = []
  end

  def run
    puts "Добро пожаловать!"
    loop do
      puts "1.Управление поездами"
      puts "2.Управление станциями"
      puts "3.Управление маршрутами" if self.stations.count > 1
      puts "4.Выход"

      user_choise = gets.chomp.to_i
      case user_choise
      when 1 then train_manage 
      when 2 then station_manage
      when 3 then route_manage
      when 4 then break
      else puts "Такого в меню нет!"
      end
    end
  end

  private
  
  def train_manage
    loop do
      puts "Меню."
      puts "1.Cоздать поезд"
      if self.trains.any?
        puts "2.Просмотреть список поездов"
        puts "3.Назначить маршрут поезду" if self.routes.any?
        puts "4.Добавить вагон к поезду"
        puts "5.Отцепить вагон от поезда"
        puts "6.Управлять движением поезда" if self.routes.any?
      end
      puts "7.Назад"
      user_choise = gets.chomp.to_i
      case user_choise
      when 1 then create_train
      when 2 then list_trains
      when 3 then set_route
      when 4 then add_wagon
      when 5 then delete_wagon
      when 6 then train_move
      when 7 then return
      else puts "Такого в меню нет!"
      end
    end
  end

  def create_train
    puts "Введите название поезда"
    name = gets.chomp
    puts "Введите тип поезда: 1.Пассажирский, 2.Грузовой"
    user_choise = gets.chomp.to_i
    case user_choise
      when 1 then self.trains << PassengerTrain.new(name)
      when 2 then self.trains << CargoTrain.new(name)
      else puts "Такого варианта нет!"
    end
  end

  def list_trains
    self.trains.each.with_index(1) { |train, index| puts "#{index}. \"#{train.name}\", тип: #{train.type.to_s}, вагоны: #{train.wagons.size}" }
  end

  def add_wagon
    list_trains
    puts "К какому поезду хотите добавить вагон?"
    train_number = gets.chomp.to_i - 1 
    if (0...self.trains.count).include?(train_number)
      train = self.trains[train_number] 
      puts "Какой вагон вы хотите добавить? 1.Пассажирский, 2.Грузовой"
      user_choise = gets.chomp.to_i 
      case user_choise
        when 1 then train.add_wagon(PassengerWagon.new)
        when 2 then train.add_wagon(CargoWagon.new)
        else puts "Такого варианта нет!"
      end
    end
  end

  def delete_wagon
    list_trains
    puts "От какого поезда хотите отцепить вагон?"
    train_number = gets.chomp.to_i
    train = self.trains[train_number] if train_number < self.trains.count
    train.list_wagons
    puts "Какой вагон хотите удалить?"
    user_choise = gets.chomp.to_i
    train.delete_wagon(user_choise)
  end

  def set_route
    list_trains
    puts "К какому поезду хотите добавть маршрут:"
    user_choise = gets.chomp.to_i - 1
    if (0...self.trains.count).include?(user_choise)
      train = self.trains[user_choise]
      list_routes
      puts "Какой маршрут хотите добавть:"
      user_choise = gets.chomp.to_i - 1
      if (0...self.routes.count).include?(user_choise)
        train.route = self.routes[user_choise]
      end
    end

  end

  def train_move
    list_trains
    puts "Какой поезд будет двигаться?"
    train_number = gets.chomp.to_i - 1
    if (0...self.trains.count).include?(train_number)
      train = self.trains[train_number] if train_number < self.trains.count
      puts "Куда движется поезд? 1.Вперед, 2.Назад"
      user_choise = gets.chomp.to_i
      case user_choise
        when 1 then train.move_forward
        when 2 then train.move_backward
        else puts "Такого варианта нет!" 
      end
    else 
      puts "Неправильно выбран поезд"
    end
  end

  def station_manage
    loop do
      puts "Меню."
      puts "1.Создать станцию"
      if self.stations.any?
        puts "2.Удалить станцию"
        puts "3.Список станций"
        puts "4.Просмотреть поезда на станции"
      end
      puts "5.Назад"
      user_choise = gets.chomp.to_i
      case user_choise
        when 1 then create_station
        when 2 then delete_station
        when 3 then list_stations
        when 4 then show_station_trains
        when 5 then return
        else puts "Такого варианта нет!"
      end
    end
  end

  def create_station
    puts "Введите название станции:"
    station_name = gets.chomp
    self.stations << Station.new(station_name)
  end

  def list_stations
    puts "Список станций:"
    self.stations.each.with_index(1) { |station,index| puts "#{index}.#{station.name}" }
  end

  def delete_station
    puts "Выберите какую станцию хотите удалить:"
    list_stations
    user_choise = gets.chomp.to_i - 1
    self.stations.delete_at(user_choise)
  end

  def show_station_trains
    puts "На какой станции хотите просмотреть поезда:"
    list_stations
    user_choise = gets.chomp.to_i - 1
    if (0...self.stations.count).include?(user_choise)
      station = self.stations[user_choise]
      puts "На станции \"#{station.name}\" находятся:"
      puts station.list_trains
    else
      puts "Неправильно выбрана станция"
    end
  end

  def route_manage
    loop do
      puts "Меню."
      puts "1.Создать маршрут"
      if self.routes.any?
        puts "2.Добавить станцию к маршруту"
        puts "3.Удалить станцию из маршрута"
        puts "4.Список маршрутов"
      end
      puts "5.Назад"
      user_choise = gets.chomp.to_i
      case user_choise
        when 1 then create_route
        when 2 then route_add_station
        when 3 then route_delete_station
        when 4 then list_routes
        when 5 then return
        else puts "Такого варианта нет!"
      end
    end
  end

  def create_route
    list_stations
    puts "Выберите первую станцию:"
    first_station_index = gets.chomp.to_i - 1
    puts "Выберите последнюю станцию:"
    last_station_index = gets.chomp.to_i - 1
    if correct_station_indexes?(first_station_index,last_station_index)
      self.routes << Route.new(self.stations[first_station_index],self.stations[last_station_index])
    else
      puts "Неправильные индексы станций"
    end
  end

  def route_add_station
    list_routes
    puts "В какой маршрут вы хотите добавить станцию:"
    user_choise = gets.chomp.to_i - 1
    if (0...self.routes.count).include?(user_choise)
      route = self.routes[user_choise]
      list_stations
      puts "какую станцию вы хотите добавить:"
      user_choise = gets.chomp.to_i - 1 
      station = self.stations[user_choise] if (0...self.stations.count).include?(user_choise)
      route.add_station(station)
    else
      puts "Неправильно выбран маршрут"
    end 
  end

  def route_delete_station
    list_routes
    puts "Из какого маршрута вы хотите удалить станцию:"
    user_choise = gets.chomp.to_i - 1
    if (0...self.routes.count).include?(user_choise)
      route = self.routes[user_choise]
      puts route.to_s
      puts "Какую станцию вы хотите удалить:"
      user_choise = gets.chomp.to_i - 1 
      station = route.stations[user_choise] if (0...route.stations.count).include?(user_choise)
      route.delete_station(station)
    else
      puts "Неправильно выбран маршрут"
    end 
  end

  def list_routes
    puts "Маршруты:"
    self.routes.each.with_index(1) { |route,index|
      puts "#{index}. #{route.to_s}"
    }
  end

  def correct_station_indexes?(first, last)
    first < self.stations.count &&
    last < self.stations.count &&
    first != last
  end

end

m = ControlPanel.new
m.run
