class BankEmployee < ActiveRecord::Base
  def self.create_employee_for_user(name, surname, patronymic, email, phone)

    bank_employee_find = BankEmployee.find_by(name: name,
                                              surname: surname,
                                              patronymic: patronymic,
                                              mobile_phone: phone,
                                              email: email)
    if bank_employee_find.nil?
      return BankEmployee.create(name: name,
                                        surname: surname,
                                        patronymic: patronymic,
                                        mobile_phone: phone,
                                        email: email)
    else
      return bank_employee_find

    end
  end
end
