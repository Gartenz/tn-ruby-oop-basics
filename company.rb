module Company
  class CompanyNameError < StandardError
    def message
      'Пустное название имени комании.'
    end
  end

  attr_accessor :company_name

  protected

  def validate_company_name!(company_name)
    raise CompanyNameError if company_name.empty?
  end
end
