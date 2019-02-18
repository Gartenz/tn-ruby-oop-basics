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
    attr_reader :validations

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
      return unless self.class.validations

      self.class.validations.each do |validation|
        name = instance_variable_get("@#{validation[:name]}".to_sym)
        send "#{validation[:type]}_validation".to_sym, name, validation[:params]
      end
    end

    private

    def presence_validation(name, _params)
      raise PresenceValidationError if ['', nil].include?(name)
    end

    def format_validation(name, format)
      raise RegexpError if format.class != Regexp
      raise RegexpValidationError if name !~ format
    end

    def type_validation(name, type)
      raise TypeValidationError if name.class != type
    end
  end
end
