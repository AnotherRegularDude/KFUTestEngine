class Session
  include ActiveModel::Model

  attr_accessor :username, :password
  attr_reader :token, :user

  def self.user_from_token(token)
    decrypted_payload = JWEPayload.new(JSON.parse(JWE.decrypt(token, PRELOADED_RSA)))
    User.find_by(id: decrypted_payload.user_id)
  rescue JWE::DecodeError
    nil
  end

  def create_token
    @user = User.find_by(username: username)
    if @user&.authenticate(password)
      generate_token
    else
      errors.add :username, :bad_credentials
      errors.add :password, :bad_credentials
    end
    errors.empty?
  end

  private

  def generate_token
    payload = JWEPayload.new(user_id: @user.id).to_json
    @token = JWE.encrypt(payload, PRELOADED_RSA)
  end
end
