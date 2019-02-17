module Company
  class CompanyNameError < StandardError
    def message
      'Пустное название имени комании.'
    end
  end

  attr_accessor :company_name
end
