# Для пассажирских вагонов:
# +    Добавить атрибут общего кол-ва мест (задается при создании вагона)
# +    Добавить метод, который "занимает места" в вагоне (по одному за раз)
# +    Добавить метод, который возвращает кол-во занятых мест в вагоне
# +    Добавить метод, возвращающий кол-во свободных мест в вагоне.

require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize(company_name, space)
    super(company_name, space)
    @type = :passenger
  end

  def take_seat
    raise FreeSpaceError if self.free_space == 0
    self.occupied_space += 1
    self.free_space -= 1
  end
end
