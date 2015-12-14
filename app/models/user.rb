class User < ActiveRecord::Base
  belongs_to :role
  bad_attribute_names  :hash

  attr_accessor :password, :error_message
  before_save :encrypt_password


  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :name
  validates_uniqueness_of :name


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
        self.error_message = [ 'Данный пользователь уже существует.']
      end
    end
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.attributes = {hash:  Digest::MD5.hexdigest(self.salt + password).to_s}
      # self.write_attribute('hash', Digest::MD5.hexdigest(self.salt + password).to_s)
      # self.hash = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def generate_password
    self.password = SecureRandom.hex(8)
  end

  def self.create_client_user(client_id)
    client = Client.find(client_id)

    user = User.new(name: client.passport_identificational_number, role_id: 1)
    user.save_first_time

    client.user_id = user.id
    client.save

    user
  end

  def is?( requested_role )
    if self.role
      return self.role.name == requested_role.to_s
    end
    false
  end



end
