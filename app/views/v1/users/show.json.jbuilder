json.data do
  json.user { json.partial! 'shared/user', user: @user }
end
