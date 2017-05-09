# Define RSA file constants
RSA_KEY_PATH = ENV.fetch('RSA_KEY_PATH', Rails.root.join('app', 'files', 'dev_rsa.pem')).freeze
PRELOADED_RSA = OpenSSL::PKey::RSA.new File.read(RSA_KEY_PATH)

# Define helper Struct's
JWEPayload = ImmutableStruct.new(:user_id)
