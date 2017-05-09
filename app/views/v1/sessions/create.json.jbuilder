json.data do
  json.session @session, partial: 'shared/session', as: :session
  json.errors { json.partial! 'shared/model_errors', errors: @session.errors }
end
