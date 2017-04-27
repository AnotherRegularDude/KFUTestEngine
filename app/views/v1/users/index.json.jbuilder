json.data do
  json.users @users do |user|
    json.partial! 'shared/user', user: user
  end
end
