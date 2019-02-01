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
      puts "1. Управление поездами"
      puts "2. Управление станциями"
      puts "3. Управление маршрутами"
      puts "4. Выход"

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
      puts "1.Cоздать поезд"
      if self.trains.any?
        puts "2.Просмотреть список поездов"
        puts "3.Назначить маршрут поезду" if routes.any?
        puts "4.Добавить вагон к поезду"
        puts "5.Отцепить вагон от поезда"
        puts "6.Управлять движением поезда"
        puts "7.Назад"
      end

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
    train = case user_choise
      when 1 then PassengerTrain.new(name)
      when 2 then CargoTrain.new(name)
      end
    self.trains << train
  end

  def list_trains
    self.trains.each_with_index { |train, index| puts "#{index}. \"#{train.name}\", тип: #{train.type.to_s}, вагоны: #{train.wagons.size}" }
  end

  def add_wagon
    loop do
      list_trains
      puts "К какому поезду хотите добавить вагон?"
      train_number = gets.chomp.to_i
      train = self.trains[train_number]
      puts "Какой вагон вы хотите добавить? 1.Пассажирский, 2.Грузовой"
      user_choise = gets.chomp.to_i 
      wagon = case user_choise
        when 1 then PassengerWagon.new
      end
    end
  end


end

m = ControlPanel.new
m.run
