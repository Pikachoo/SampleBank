class BankEmployee < ActiveRecord::Base
  def self.create_employee_for_user(name, surname, patonymic, email, phone)

    bank_employee_find = BankEmployee.find_by(name: employee_name,
                                              surname: employee_surname,
                                              patronymic: employee_patronymic,
                                              mobile_phone: employee_mobile_phone,
                                              email: employee_email)
    if bank_employee_find.nil?
      return BankEmployee.create(name: employee_name,
                                        surname: employee_surname,
                                        patronymic: employee_patronymic,
                                        mobile_phone: employee_mobile_phone,
                                        email: employee_email)
    else
      return

    end
  end
end
