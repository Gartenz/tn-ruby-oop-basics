module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.send :include, InstanceMethods
  end

  class RegexpValidationError < StandardError
    def message
      'Значение не совпадает с форматом'
    end
  end

  class PresenceValidationError < StandardError
    def message
      "Значение 'nil'"
    end
  end

  class TypeValidationError < StandardError
    def message
      'Значение не совпадает с типом'
    end
  end

  module ClassMethods
    def validate(name, type, params = nil)
      @validations ||= []
      @validations << { name: name, type: type, params: params }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    def validate!
      self.class.validates.each do |validation|
        case validation[:type]
        when :presence then presence_validation(attr_name)
        when :format then format_validation(validation[:name], validation[:param])
        when :type then type_validation(validation[:name], validation[:param])
        else
          raise ArgumentError, "Ошибка в параметре 'type'"
        end
      end
    end

    private

    def presence_validation(name)
      raise PresenceValidationError if ['', nil].include?(instance_variable_get(name))
    end

    def format_validation(name, format)
      raise RegexpError if format.class != Regexp
      raise RegexpValidationError if instance_variable_get(name) !~ format
    end

    def type_validation(name, type)
      raise TypeValidationError if instance_variable_get(name).class != type
    end
  end
end
