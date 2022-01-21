class Encryptor
  KEY_BASE = ActiveSupport::MessageEncryptor.new(ENV["SECRET_KEY_BASE"][0..31])

  def self.encrypt(data)
    KEY_BASE.encrypt_and_sign(data)
  end

  def self.decrypt(data)
    KEY_BASE.decrypt_and_verify(data)
  end
end