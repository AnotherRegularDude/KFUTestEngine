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

  private

  def generate_token
    payload = {
      user_id: @user.id,
      created_time: Time.current
    }.to_json

    @token = JWE.encrypt(payload, rsa_key)
  end

  def rsa_key
    OpenSSL::PKey::RSA.new File.read RSA_KEY_PATH
  end
end
