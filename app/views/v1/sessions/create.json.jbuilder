json.data do
  json.session @session, partial: 'shared/session', as: :session
  json.errors @session.errors
end
