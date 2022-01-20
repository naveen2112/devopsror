module EncryptCredentails

  def initialize
    ActiveSupport::MessageEncryptor.new(ENV["SECRET_KEY_BASE"][0..31])
  end

  def encrypt(data)
    initialize.encrypt_and_sign(data)
  end

  def decrypt(data)
    initialize.decrypt_and_verify(data)
  end
end