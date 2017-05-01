class Session
  include ActiveModel::Model

  attr_accessor :username, :password
  attr_accessor :token

  def create_token
    @user = User.find_by(username: username)
    if @user.present? && @user.authenticate(password)
      generate_token
    else
      errors.add :username, :bad_credentials
      errors.add :password, :bad_credentials
    end
    errors.empty?
  end

  def user_from_token
    decrypted_payload = JWEPayload.new(JSON.parse(JWE.decrypt(token, rsa_key)))
    User.find_by(id: decrypted_payload.user_id)
  end

  private

  class JWEPayload
    include ActiveModel::Model

    attr_accessor :user_id
  end

  def generate_token
    payload = JWEPayload.new(user_id: @user.id).to_json

    @token = JWE.encrypt(payload, rsa_key)
  end

  def rsa_key
    OpenSSL::PKey::RSA.new File.read RSA_KEY_PATH
  end
end
