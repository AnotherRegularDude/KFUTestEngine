json.data do
  json.session @session, partial: 'shared/session', as: :session
  if @session.token.present?
    json.user @session.user, partial: 'shared/user', as: :user
  else
    json.set! :user, {}
  end
  json.errors { json.partial! 'shared/model_errors', errors: @session.errors }
end
