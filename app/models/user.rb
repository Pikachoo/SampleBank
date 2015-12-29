class User < ActiveRecord::Base
  belongs_to :role
  bad_attribute_names :hash

  attr_accessor :password, :error_message
  before_save :encrypt_password


  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :name
  validates_uniqueness_of :name

  paginates_per 25


  def self.authenticate(name, password)
    user = find_by_name(name)
    if user && user[:hash] == Digest::MD5.hexdigest(user.salt+password).to_s
      user
    else
      nil
    end
  end

  def save_user_employee(bank_employee)
    self.generate_password
    if self.valid?
      self.save

      phone_number = bank_employee.mobile_phone[1..-1]
      email = bank_employee.email
      text = "Пользователь создан.\nИмя: #{self.name}\nПароль: #{self.password}"

      User.send_sms(phone_number, text)
      User.send_email(email, text) if email != ''
      return self
    else
      if self.errors[:name].empty?  == false
        self.error_message = ['Данный пользователь уже существует.']
      end
      user = User.find_by_name(self.name)
      user.error_message = self.error_message
      return user
    end
  end

  def save_first_time(client = nil)
    self.generate_password
    if self.valid?
      self.save
      if client.nil? == false
        phone_number = client.phone_mobile[1..-1]
        email = client.email
        text = "Пользователь создан.\nИмя: #{self.name}\nПароль: #{self.password}"

        User.send_sms(phone_number, text)
        User.send_email(email, text) if email != ''
      end

    else
      if self.errors[:name].empty?  == false
        self.error_message =  ['Данный пользователь уже существует.']
      end
      user = User.find_by_name(self.name)
      user.error_message = self.error_message
      return user
    end
    self
  end

  def self.send_sms(telephone_number, text)
    uri = URI('http://rude-php.com/rude-sms/')
    params = {:phone => telephone_number, :message => text}
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)

    puts uri
    res.body
  end

  def send_sms(text)
    if self.is? 'client'
      client = Client.find_by(user_id: self.id)
      telephone_number = client.phone_mobile[1..-1] if client
    else
      employee = BankEmployee.find_by(user_id: self.id)
      telephone_number = employee.mobile_phone[1..-1] if employee
    end
    if telephone_number
      uri = URI('http://rude-php.com/rude-sms/')
      params = {:phone => telephone_number, :message => text}
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)

      puts uri
      res.body
    end
  end

  def self.send_email(email, text)
    uri = URI('http://rude-php.com/rude-email/?task=send&from=Bank')
    params = {:task => 'send',
              :from => 'RudeBank',
              :to => email,
              :subject => 'RUDE bank оповещение',
              :text => text}
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)

    puts uri
    res.body

  end

  def send_email(text)
    if self.is? 'client'
      client = Client.find_by(user_id: self.id)
      email = client.email if client
    else
      employee = BankEmployee.find_by(user_id: self.id)
      email = employee.email if employee
    end
    if email
      uri = URI('http://rude-php.com/rude-email/?task=send&from=Bank')
      params = {:task => 'send',
                :from => 'RudeBank',
                :to => email,
                :subject => 'RUDE bank оповещение',
                :text => text}
      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)

      puts uri
      res.body
    end
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.attributes = {hash: Digest::MD5.hexdigest(self.salt + password).to_s}
    end
  end

  def generate_password
    self.password = SecureRandom.hex(4)
  end

  def self.create_user_for_client(client_id)
    client = Client.find(client_id)

    if client
      user = User.new(name: client.passport_identificational_number, role_id: 1)
      user_find = User.find_by(name: client.passport_identificational_number)
      if !user_find
        user = user.save_first_time(client)
      else
        user = user_find
      end

      client.user_id = user.id
      client.save
      user
    end

  end
  def custom_update(params)

    user_find = User.find_by_name(params[:name])
    if user_find.nil? || self.name == params[:name]
      self.update(params)

      bank_employee = BankEmployee.find_by(user_id: self.id)
      phone_number = bank_employee.mobile_phone[1..-1]
      email = bank_employee.email
      text = "Пользователь обновлен.\nИмя: #{self.name}\nРоль: #{self.role.name}"

      User.send_sms(phone_number, text)
      User.send_email(email, text) if email != ''
      return self
    else

      user = User.find_by_name(self.name)
      user.error_message = ["Пользователь с  именем #{params[:name]} уже существует."]
      puts json: user
      return user
    end
  end


  def is?(requested_role)
    if self.role
      return self.role.name == requested_role.to_s
    end
    false
  end


end
