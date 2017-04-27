json.data do
  json.user @user, partial: 'shared/user', as: :user
  json.errors @user.errors
end
