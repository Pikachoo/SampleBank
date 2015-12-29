class Credit < ActiveRecord::Base
  belongs_to :currency
  has_many :credit_grantings
  has_many :credit_warrenties
  has_many :credit_payments
  has_many :client_credits

  attr_accessor :error_message

  def get_credit_payments
    credit_payments = CreditPayment.where(credit_id: self.id)
    puts json: credit_payments
    payments_ids = Array.new
    credit_payments.each { |credit_payment| payments_ids.push(credit_payment.payment_type_id) }
    payments = CreditPaymentType.where(id: payments_ids)
    payments
  end

  def get_credit_warrenties
    credit_warrenties = CreditWarrenty.where(credit_id: self.id)
    puts json: credit_warrenties
    warrenty_ids = Array.new
    credit_warrenties.each { |credit_warrenty| warrenty_ids.push(credit_warrenty.warrenty_type_id) }
    puts json: warrenty_ids
    warrenties = CreditWarrentyType.where(id: warrenty_ids)
    warrenties
  end

  def get_credit_grantings
    credit_grantings = CreditGranting.where(credit_id: self.id)
    puts json: credit_grantings
    grantings_ids = Array.new
    credit_grantings.each { |credit_granting| grantings_ids.push(credit_granting.granting_type_id) }
    grantings = CreditGrantingType.where(id: grantings_ids)
    grantings
  end

  def destroy_credit_and_dependecies()
    Credit.transaction do
      begin

        self.destroy_credit_dependecies
        # self.destroy
        self.update_attributes(is_active: false)
      rescue
        raise ActiveRecord::Rollback
      end
    end
  end

  def destroy_credit_dependecies
    credit_grantings = CreditGranting.where(credit_id: self.id)
    credit_grantings.each do |granting|
      granting.update_attributes(is_active: false)
      # granting.destroy
    end

    credit_payments = CreditPayment.where(credit_id: self.id)
    credit_payments.each do |payment|
      # payment.destroy
      payment.update_attributes(is_active: false)
    end

    credit_warrenties = CreditWarrenty.where(credit_id: self.id)
    credit_warrenties.each do |warrenty|
      # warrenty.destroy
      warrenty.update_attributes(is_active: false)
    end

  end

  def save_credit_and_dependecies(warrenty_types, granting_types, payment_types)
    Credit.transaction do
      begin
        credit_find = Credit.find_by_name(self.name)
        if credit_find.nil?
          self.save

          credit_warrenty_ids = warrenty_types
          credit_warrenty_ids = credit_warrenty_ids.split(",").map { |s| s.to_i }
          credit_warrenty_ids.each do |warrenty|
            CreditWarrenty.create(credit_id: self.id, warrenty_type_id: warrenty)
          end


          credit_granting_ids = granting_types
          credit_granting_ids = credit_granting_ids.split(",").map { |s| s.to_i }
          credit_granting_ids.each do |granting|
            CreditGranting.create(credit_id: self.id, granting_type_id: granting)
          end

          credit_payment_ids = payment_types
          credit_payment_ids = credit_payment_ids.split(",").map { |s| s.to_i }
          credit_payment_ids.each do |payment|
            CreditPayment.create(credit_id: self.id, payment_type_id: payment)
          end
          return 'Кредит создан.'
        else
          return 'Кредит с таким именем уже существует.'
        end
      rescue
        raise ActiveRecord::Rollback
      end
    end
  end
  def custom_update(params, warrenty_types, granting_types, payment_types)
    credit_find = Credit.find_by_name(params[:name])
    if credit_find.nil? || self.name == params[:name]
      self.update(params)
      self.update_dependecies(warrenty_types, granting_types, payment_types)
    else
      self.error_message = ["Кредит с именем #{params[:name]} уже существует."]
    end
    return self
  end

  def update_dependecies(warrenty_types, granting_types, payment_types)
    Credit.transaction do
      begin
        self.destroy_credit_dependecies

        credit_warrenty_ids = warrenty_types
        credit_warrenty_ids = credit_warrenty_ids.split(",").map { |s| s.to_i }
        credit_warrenty_ids.each do |warrenty|
          credit_warrenty = CreditWarrenty.find_by(credit_id: self.id, warrenty_type_id: warrenty)
          if credit_warrenty.nil?
            CreditWarrenty.create(credit_id: self.id, warrenty_type_id: warrenty)
          end
        end

        credit_granting_ids = granting_types
        credit_granting_ids = credit_granting_ids.split(",").map { |s| s.to_i }
        credit_granting_ids.each do |granting|
          if CreditGranting.find_by(credit_id: self.id, granting_type_id: granting).nil?
            CreditGranting.create(credit_id: self.id, granting_type_id: granting)
          end
        end


        credit_payment_ids = payment_types
        credit_payment_ids = credit_payment_ids.split(",").map { |s| s.to_i }
        credit_payment_ids.each do |payment|
          if CreditPayment.find_by(credit_id: self.id, payment_type_id: payment).nil?
            CreditPayment.create(credit_id: self.id, payment_type_id: payment)
          end
        end
      rescue
        raise ActiveRecord::Rollback
      end
    end

  end
end
