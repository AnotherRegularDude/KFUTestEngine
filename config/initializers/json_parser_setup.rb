# Configure JSON serializer
Oj.mimic_JSON
Oj.default_options = { mode: :json, omit_nil: true }
Jbuilder.key_format camelize: :lower

# Underscore params, if camelcased
ActionDispatch::Request.parameter_parsers[:json] = lambda do |raw_post|
  # Modified from action_dispatch/http/parameters.rb
  data = JSON.parse(raw_post)

  # Transform camelCase param keys to snake_case:
  data.deep_transform_keys!(&:underscore)
end
