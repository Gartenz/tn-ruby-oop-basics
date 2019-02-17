module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        var_name_history = "@#{name}_history".to_sym

        define_method(name) do
          instance_variable_get(var_name)
        end

        define_method("#{name}_history") do
          instance_variable_get(var_name_history)
        end

        define_method("#{name}=") do |value|
          if instance_variable_get(var_name).nil?
            instance_variable_set(var_name_history, [])
          else
            instance_variable_get(var_name_history).push(value)
          end
          instance_variable_set(var_name, value)
        end
      end
    end

    def strong_attr_accessor(names = {})
      names.each do |name, class_type|
        var_name = "@#{name}".to_sym
        define_method(name) do
          instance_variable_get(var_name)
        end

        define_method("#{name}=") do |value|
          raise TypeError unless class_type == value.class

          instance_variable_set(var_name, value)
        end
      end
    end
  end
end
