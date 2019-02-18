require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_train'
require_relative 'passenger_wagon'
require_relative 'route'
require_relative 'station'
require_relative 'accessor'
require_relative 'validation'

# rubocop:disable Metrics/ClassLength
class ControlPanel
  include Accessors
  include Validation

  strong_attr_accessor trains: Array, routes: Array, stations: Array

  validate :trains, :presence
  validate :routes, :presence
  validate :stations, :presence

  def initialize
    @trains = []
    @routes = []
    @stations = []
    validate!
  end

  def run
    loop do
      begin
        show_menu(MAIN_MENU)
        user_choise = gets.chomp.to_i
        return if user_choise.zero?

        send MAIN_ROUTE[user_choise]
      rescue TypeError
        puts 'Неправильно выбран пункт меню.'
        retry
      end
    end
  end

  private

  MAIN_MENU = ['Добро пожаловать!', '1.Управление поездами', '2.Управление станциями',
               '3.Управление маршрутами', '0.Выход'].freeze
  TRAIN_MENU = ['1.Cоздать поезд', '2.Просмотреть список поездов',
                '3.Назначить маршрут поезду', '4.Добавить вагон к поезду',
                '5.Отцепить вагон от поезда', '6.Управлять движением поезда',
                '7.Вывести список вагон у поезда', '0.Назад'].freeze
  STATION_MENU = ['1.Создать станцию', '2.Удалить станцию',
                  '3.Список станций', '4.Просмотреть поезда на станции',
                  '5.Добавить груз поезду', '0.Назад'].freeze
  ROUTE_MENU = ['1.Создать маршрут', '2.Добавить станцию к маршруту',
                '3.Удалить станцию из маршрута', '4.Список маршрутов', '0.Назад'].freeze

  MAIN_ROUTE = { 1 => :train_manage, 2 => :station_manage, 3 => :route_manage }.freeze
  TRAIN_ROUTE = { 1 => :create_train, 2 => :list_all_trains, 3 => :set_route,
                  4 => :add_wagon, 5 => :delete_wagon, 6 => :train_move,
                  7 => :train_list_wagons }.freeze
  STATION_ROUTE = { 1 => :create_station, 2 => :delete_station, 3 => :list_stations,
                    4 => :show_station_trains, 5 => :add_train_space }.freeze
  ROUTE_ROUTE = { 1 => :create_route, 2 => :route_add_station,
                  3 => :route_delete_station, 4 => :list_routes }.freeze

  def show_menu(menu)
    menu.each { |x| puts x }
  end

  def train_manage
    loop do
      begin
        show_menu(TRAIN_MENU)
        user_choise = gets.chomp.to_i
        return if user_choise.zero?

        send(TRAIN_ROUTE[user_choise])
      rescue TypeError
        puts 'Неправильно выбран пункт меню.'
        retry
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def create_train
    begin
      puts 'Введите название поезда:'
      train_number = gets.chomp
      puts 'Введите название компании:'
      company_name = gets.chomp
      puts 'Введите тип поезда: 1.Пассажирский, 2.Грузовой'
      user_choise = gets.chomp.to_i
      train = case user_choise
              when 1 then PassengerTrain.new(train_number, company_name)
              when 2 then CargoTrain.new(train_number, company_name)
              end
      trains << train
    rescue Train::NameError, Train::CompanyNameError => e
      puts e.message
      retry
    end
    puts "Создан поезд с номером: #{train_number} от компании: #{company_name}"
  end
  # rubocop:enable Metrics/AbcSize

  def list_all_trains
    trains.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number} вагоны: #{train.wagons.size}"
    end
  end

  # rubocop:disable Metrics/AbcSize
  def add_wagon
    list_all_trains
    puts 'К какому поезду хотите добавить вагон?'
    train_number = gets.chomp.to_i - 1
    return if train_number > trains.count

    train = trains[train_number]
    puts 'Какой вагон вы хотите добавить? 1.Пассажирский, 2.Грузовой'
    user_choise = gets.chomp.to_i
    puts 'Введите название компании:'
    company_name = gets.chomp
    puts 'Введите количество свободного место в вагоне:'
    space = gets.chomp.to_f
    case user_choise
    when 1
      train.add_wagon(PassengerWagon.new(company_name, space.to_i))
    when 2
      train.add_wagon(CargoWagon.new(company_name, space))
    else puts 'Такого варианта нет!'
    end
  rescue Train::WagonError, Wagon::CompanyNameError => e
    puts e.message
    retry
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:disable Metrics/AbcSize
  def delete_wagon
    list_all_trains
    puts 'От какого поезда хотите отцепить вагон?'
    train_number = gets.chomp.to_i - 1
    return if train_number > trains.count

    train = trains[train_number]
    train.wagons.each_with_index do |wagon, index|
      puts "#{index}.#{wagon.company_name}"
    end
    puts 'Какой вагон хотите удалить?'
    user_choise = gets.chomp.to_i
    train.delete_wagon(user_choise)
  end

  # rubocop:enable Metrics/AbcSize
  # rubocop:disable Metrics/AbcSize
  def set_route
    list_all_trains
    puts 'К какому поезду хотите добавть маршрут:'
    user_choise = gets.chomp.to_i - 1
    return if user_choise > trains.count

    train = trains[user_choise]
    list_routes
    puts 'Какой маршрут хотите добавть:'
    user_choise = gets.chomp.to_i - 1
    train.route = routes[user_choise] if user_choise <= routes.count
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def train_move
    list_all_trains
    puts 'Какой поезд будет двигаться?'
    train_number = gets.chomp.to_i - 1
    return if train_number > trains.count

    train = trains[train_number]
    begin
      puts 'Куда движется поезд? 1.Вперед, 2.Назад, 0.Отмена'
      user_choise = gets.chomp.to_i
      case user_choise
      when 1 then train.move_forward
      when 2 then train.move_backward
      when 0 then return
      end
    rescue Train::MovementError => e
      puts e.message
      retry
    end
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def train_list_wagons
    list_all_trains
    puts 'У какого поезда хотите просмотреть список вагонов?'
    train_choise = gets.chomp.to_i - 1
    return if train_choise > trains.count

    trains[train_choise].each_wagon do |wagon|
      puts "Компания: #{wagon.company_name}, всего: #{wagon.total_space}"\
        " свободно: #{wagon.free_space}"
    end
  end
  # rubocop:enable Metrics/AbcSize

  def station_manage
    loop do
      begin
        show_menu(STATION_MENU)
        user_choise = gets.chomp.to_i
        return if user_choise.zero?

        send STATION_ROUTE[user_choise]
      rescue TypeError
        puts 'Неправильно выбран пункт меню.'
        retry
      end
    end
  end

  def create_station
    puts 'Введите название станции:'
    station_name = gets.chomp
    stations << Station.new(station_name)
  rescue Station::NameError, Station::UniquenessError => e
    puts e
    retry
  end

  def list_stations
    puts 'Список станций:'
    stations.each.with_index(1) { |station, index| puts "#{index}.#{station.name}" }
  end

  def delete_station
    puts 'Выберите какую станцию хотите удалить:'
    list_stations
    user_choise = gets.chomp.to_i - 1
    stations.delete_at(user_choise)
  end

  def list_station_trains(station)
    puts "На станции #{station.name} находятся:"
    station.each_train_with_index(1) do |train, index|
      puts "#{index}. #{train.number} вагонов: #{train.wagons.count}"
    end
  end

  def show_station_trains
    station = select_station
    list_station_trains(station)
  end

  # rubocop:disable Metrics/AbcSize
  def add_train_space
    station = select_station
    list_station_trains(station)
    puts 'Какому поезду вы хотите добавить груз?'
    train_choise = gets.chomp.to_i - 1
    return if train_choise > trains.count

    train = station.trains[train_choise]
    puts 'В какой вагон вы хотите добавить груз?'
    train.each_wagon_with_index(1) do |wagon, index|
      puts "#{index}, свободно: #{wagon.free_space}"
    end
    wagon_choise = gets.chomp.to_i - 1
    return if wagon_choise > train.wagons.count

    wagon = train.wagons[wagon_choise]
    puts 'Сколько вы хотите добавить?'
    space = gets.chomp.to_f
    case wagon.type
    when :passenger
      people.to_i.times { wagon.take_seat }
    when :cargo
      wagon.add_cargo(space)
    end
  rescue RangeError, Wagon::FreeSpaceError => e
    puts e.message
    retry
  end
  # rubocop:enable Metrics/AbcSize

  def select_station
    puts 'Выберите:'
    list_stations
    user_choise = gets.chomp.to_i - 1
    raise RangeError, 'Неправильно выбрана станция' if user_choise > stations.count

    stations[user_choise]
  end

  def route_manage
    loop do
      begin
        show_menu(ROUTE_MENU)
        user_choise = gets.chomp.to_i
        return if user_choise.zero?

        send ROUTE_ROUTE[user_choise]
      rescue TypeError
        puts 'Неправильно выбран пункт меню.'
        retry
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def create_route
    list_stations
    puts 'Выберите первую станцию:'
    first_station_index = gets.chomp.to_i - 1
    puts 'Выберите последнюю станцию:'
    last_station_index = gets.chomp.to_i - 1
    if correct_station_indexes?(first_station_index, last_station_index)
      routes << Route.new(stations[first_station_index], stations[last_station_index])
    else
      puts 'Неправильные индексы станций'
    end
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def route_add_station
    list_routes
    puts 'В какой маршрут вы хотите добавить станцию:'
    user_choise = gets.chomp.to_i - 1
    if user_choise <= routes.count
      route = routes[user_choise]
      list_stations
      puts 'какую станцию вы хотите добавить:'
      user_choise = gets.chomp.to_i - 1
      station = stations[user_choise] if user_choise <= stations.count
      route.add_station(station)
    else
      puts 'Неправильно выбран маршрут'
    end
  rescue Route::AddStationError => e
    puts e.message
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def route_delete_station
    list_routes
    puts 'Из какого маршрута вы хотите удалить станцию:'
    user_choise = gets.chomp.to_i - 1
    return if user_choise > routes.count

    route = routes[user_choise]
    puts route.to_s
    puts 'Какую станцию вы хотите удалить:'
    user_choise = gets.chomp.to_i - 1
    return if user_choise > route.stations.count

    route.delete_station(route.stations[user_choise])
  rescue Route::DeleteStationError => e
    puts e.message
  end
  # rubocop:enable Metrics/AbcSize

  def list_routes
    puts 'Маршруты:'
    routes.each.with_index(1) do |route, index|
      puts "#{index}. #{route}"
    end
  end

  def correct_station_indexes?(first, last)
    first < stations.count &&
      last < stations.count &&
      first != last
  end
end
# rubocop:enable Metrics/ClassLength

m = ControlPanel.new
m.run
