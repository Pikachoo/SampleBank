class Credit < ActiveRecord::Base
  belongs_to :currency
  has_many :credit_grantings
  has_many :credit_warrenties
  has_many :credit_payments
  has_many :client_credits

  def get_credit_payments
    credit_payments = CreditPayment.where(credit_id: self.id)
    puts json: credit_payments
    payments_ids = Array.new
    credit_payments.each{|credit_payment| payments_ids.push(credit_payment.payment_type_id)}
    payments = CreditPaymentType.where(id: payments_ids)
    payments
  end
  def get_credit_warrenties
    credit_warrenties = CreditWarrenty.where(credit_id: self.id)
    puts json: credit_warrenties
    warrenty_ids = Array.new
    credit_warrenties.each{|credit_warrenty| warrenty_ids.push(credit_warrenty.warrenty_type_id)}
    puts json: warrenty_ids
    warrenties = CreditWarrentyType.where(id: warrenty_ids)
    warrenties
  end
  def get_credit_grantings
    credit_grantings = CreditGranting.where(credit_id: self.id)
    puts json: credit_grantings
    grantings_ids = Array.new
    credit_grantings.each{|credit_granting| grantings_ids.push(credit_granting.granting_type_id)}
    grantings = CreditGrantingType.where(id: grantings_ids)
    grantings
  end

  def destroy_credit_dependecies()
    credit_grantings = CreditGranting.where(credit_id: self.id)
    credit_grantings.each do |granting|
      granting.destroy
    end

    credit_payments = CreditPayment.where(credit_id: self.id)
    credit_payments.each do |payment|
      payment.destroy
    end

    credit_warrenties = CreditWarrenty.where(credit_id: self.id)
    credit_warrenties.each do |warrenty|
      warrenty.destroy
    end
  end

  def save_credit_dependecies(warrenty_types,  granting_types,  payment_types)

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
  end

  def update_dependecies(warrenty_types,  granting_types,  payment_types)
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

  end
end
