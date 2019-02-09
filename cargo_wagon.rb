# Для грузовых вагонов:
# +   Добавить атрибут общего объема (задается при создании вагона)
# +   Добавить метод, которые "занимает объем" в вагоне (объем указывается в качестве параметра метода)
# +   Добавить метод, который возвращает занятый объем
# +   Добавить метод, который возвращает оставшийся (доступный) объем

require_relative 'wagon'

class CargoWagon < Wagon
  def initialize(company_name, space)
    super(company_name, space)
    @type = :cargo
  end

  def add_cargo(space)
    raise FreeSpaceError if self.free_space < space
    self.occupied_space += space
    self.free_space -= space 
  end
end
