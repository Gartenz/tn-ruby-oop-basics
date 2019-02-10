#  Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
#      - Создавать станции
#      - Создавать поезда
#      - Создавать маршруты и управлять станциями в нем (добавлять, удалять)
#      - Назначать маршрут поезду
#      - Добавлять вагоны к поезду
#      - Отцеплять вагоны от поезда
#      - Перемещать поезд по маршруту вперед и назад
#      - Просматривать список станций и список поездов на станции

# Если у вас есть интерфейс, то добавить возможности:
#  +   При создании вагона указывать кол-во мест или общий объем, в зависимости от типа вагона
#  +   Выводить список вагонов у поезда (в указанном выше формате), используя созданные методы
#  +   Выводить список поездов на станции (в указанном выше формате), используя  созданные методы
#  +   Занимать место или объем в вагоне

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
      puts "0.Выход"

      user_choise = gets.chomp.to_i
      case user_choise
      when 1 then train_manage 
      when 2 then station_manage
      when 3 then route_manage
      when 0 then break
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
        puts "7.Вывести список вагон у поезда"
      end
      puts "0.Назад"
      user_choise = gets.chomp.to_i
      case user_choise
      when 1 then create_train
      when 2 then list_all_trains
      when 3 then set_route
      when 4 then add_wagon
      when 5 then delete_wagon
      when 6 then train_move
      when 7 then train_list_wagons
      when 0 then return
      else puts "Такого в меню нет!"
      end
    end
  end

  def create_train
    begin
      puts "Введите название поезда:"
      train_number = gets.chomp
      puts "Введите название компании:"
      company_name = gets.chomp
      puts "Введите тип поезда: 1.Пассажирский, 2.Грузовой"
      user_choise = gets.chomp.to_i
      case user_choise
        when 1 then self.trains << PassengerTrain.new(train_number, company_name)
        when 2 then self.trains << CargoTrain.new(train_number, company_name)
        else puts "Такого варианта нет!"
      end
    rescue Train::NameError, Train::CompanyNameError => e
      puts e.message
      retry
    end
    puts "Создан поезд с номером: #{train_number} от компании: #{company_name}"
  end

  def list_all_trains
    self.trains.each.with_index(1) do |train, index|
      puts "#{index}. \"#{train.number}\", тип: #{train.type.to_s}, вагоны: #{train.wagons.size}"
    end
  end

  def add_wagon
    list_all_trains
    puts "К какому поезду хотите добавить вагон?"
    train_number = gets.chomp.to_i - 1 
    if train_number <= self.trains.count
      train = self.trains[train_number]
      begin 
        puts "Какой вагон вы хотите добавить? 1.Пассажирский, 2.Грузовой"
        user_choise = gets.chomp.to_i
        puts "Введите название компании:"
        company_name = gets.chomp
        case user_choise
          when 1 
            puts "Введите количество мест в вагоне:"
            space = gets.chomp.to_i
            train.add_wagon(PassengerWagon.new(company_name, space))
          when 2
            puts "Введите грузовой объем(т.) вагона:"
            space = gets.chomp.to_f 
            train.add_wagon(CargoWagon.new(company_name, space))
          else puts "Такого варианта нет!"
        end
      rescue Train::WagonError, Wagon::CompanyNameError => e
        puts e.message
        retry
      end
    end
  end

  def delete_wagon
    list_all_trains
    puts "От какого поезда хотите отцепить вагон?"
    train_number = gets.chomp.to_i - 1
    train = self.trains[train_number] if train_number < self.trains.count
    
    puts "Количество вагонов у поезда \"#{train.number}\": #{train.wagons.size}"
    train.wagons.each_with_index { |wagon,index| puts "#{index}.#{wagon.company_name} тип: #{wagon.type}" }

    puts "Какой вагон хотите удалить?"
    user_choise = gets.chomp.to_i
    train.delete_wagon(user_choise)
  end

  def set_route
    list_all_trains
    puts "К какому поезду хотите добавть маршрут:"
    user_choise = gets.chomp.to_i - 1
    if user_choise <= self.trains.count
      train = self.trains[user_choise]
      list_routes
      puts "Какой маршрут хотите добавть:"
      user_choise = gets.chomp.to_i - 1
      if user_choise <= self.routes.count
        train.route = self.routes[user_choise]
      end
    end

  end

  def train_move
    list_all_trains
    puts "Какой поезд будет двигаться?"
    train_number = gets.chomp.to_i - 1
    if train_number <= self.trains.count
      train = self.trains[train_number] if train_number < self.trains.count
      begin
        puts "Куда движется поезд? 1.Вперед, 2.Назад, 0.Отмена"
        user_choise = gets.chomp.to_i
        case user_choise
          when 1 then train.move_forward
          when 2 then train.move_backward
          when 0 then return
          else puts "Такого варианта нет!" 
        end
      rescue Train::MovementError => e
        puts e.message
        retry
      end
    else 
      puts "Неправильно выбран поезд"
    end
  end

  def train_list_wagons
    list_all_trains
    puts "У какого поезда хотите просмотреть список вагонов?"
    train_choise = gets.chomp.to_i - 1
    if train_choise <= self.trains.count
      train = self.trains[train_choise]
      puts "Поезд #{train.number} имеет кол-во вагоно #{train.wagons.count}:"
      train.each_wagon do |wagon|
        puts "Компания: #{wagon.company_name}, всего места: #{wagon.total_space}"\
          " свободно: #{wagon.free_space} занято:#{wagon.occupied_space}"
      end
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
        puts "5.Добавить груз поезду" if self.trains.any?
      end
      puts "0.Назад"
      user_choise = gets.chomp.to_i
      case user_choise
        when 1 then create_station
        when 2 then delete_station
        when 3 then list_stations
        when 4 then show_station_trains
        when 5 then add_train_space
        when 0 then return
        else puts "Такого варианта нет!"
      end
    end
  end

  def create_station
    begin
      puts "Введите название станции:"
      station_name = gets.chomp
      self.stations << Station.new(station_name)
    rescue Station::NameError, Station::UniquenessError => e
      puts e
      retry
    end
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

  def list_station_trains(station)
    puts "На станции #{station.name} находятся:"
    station.each_train_with_index(1) do |train, index|
      puts "#{index}. \"#{train.number}\" тип: #{train.type} кол-во вагонов: #{train.wagons.count}"
    end
  end

  def show_station_trains
    station = get_station
    list_station_trains(station)
  end

  def add_train_space
    station = get_station
    list_station_trains(station)
    puts "Какому поезду вы хотите добавить груз?"
    train_choise = gets.chomp.to_i - 1
    if train_choise <= self.trains.count
      train = station.trains[train_choise]
      puts "В какой вагон вы хотите добавить груз?"
      train.each_wagon_with_index(1) do |wagon, index|
        puts "#{index}. тип: #{wagon.type} свободного места: #{wagon.free_space}"
      end
      wagon_choise = gets.chomp.to_i - 1
      if wagon_choise <= train.wagons.count
        wagon = train.wagons[wagon_choise]
        begin
          puts "Сколько груза вы хотите добавить?"
          case wagon.type
            when :passenger
              people = gets.chomp.to_i
              people.times { wagon.take_seat }
            when :cargo
              space = gets.chomp.to_f
              wagon.add_cargo(space)
          end
        rescue Wagon::FreeSpaceError => e
          puts e.message
        end
      end
    end
  rescue RangeError => e
    puts e.message
    retry
  end

  def get_station
    puts "Выберите:"
    list_stations
    user_choise = gets.chomp.to_i - 1
    if user_choise <= self.stations.count
      station = self.stations[user_choise]
    else
      raise RangeError, "Неправильно выбрана станция"
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
      puts "0.Назад"
      user_choise = gets.chomp.to_i
      case user_choise
        when 1 then create_route
        when 2 then route_add_station
        when 3 then route_delete_station
        when 4 then list_routes
        when 0 then return
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
    if user_choise <= self.routes.count
      route = self.routes[user_choise]
      list_stations
      puts "какую станцию вы хотите добавить:"
      user_choise = gets.chomp.to_i - 1 
      station = self.stations[user_choise] if user_choise <= self.stations.count
      route.add_station(station)
    else
      puts "Неправильно выбран маршрут"
    end
    rescue Route::AddStationError => e
      puts e.message 
  end

  def route_delete_station
    list_routes
    puts "Из какого маршрута вы хотите удалить станцию:"
    user_choise = gets.chomp.to_i - 1
    if user_choise <= self.routes.count
      route = self.routes[user_choise]
      puts route.to_s
      puts "Какую станцию вы хотите удалить:"
      user_choise = gets.chomp.to_i - 1 
      station = route.stations[user_choise] if user_choise <= route.stations.count
      route.delete_station(station)
    else
      puts "Неправильно выбран маршрут"
    end 
  rescue Route::DeleteStationError => e
    puts e.message
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
