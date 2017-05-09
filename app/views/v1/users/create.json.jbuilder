json.data do
  json.user @user, partial: 'shared/user', as: :user
  json.errors { json.partial! 'shared/model_errors', errors: @user.errors }
end
