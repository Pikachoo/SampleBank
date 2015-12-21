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

  def save_first_time
    self.generate_password
    if self.valid?
      self.save
    else
      if self.errors[:name]
        self.error_message = ['Данный пользователь уже существует.']
      end
    end
    self
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.attributes = {hash: Digest::MD5.hexdigest(self.salt + password).to_s}
    end
  end

  def generate_password
    self.password = SecureRandom.hex(8)
  end

  def self.create_user_for_client(client_id)
    client = Client.find(client_id)

    if client
      user = User.new(name: client.passport_identificational_number, role_id: 1)
      user_find = User.find_by(name: client.passport_identificational_number)
      if !user_find
        user = user.save_first_time
      else
        user = user_find
      end

      client.user_id = user.id
      client.save
      user
    end

  end


  def is?(requested_role)
    if self.role
      return self.role.name == requested_role.to_s
    end
    false
  end


end
