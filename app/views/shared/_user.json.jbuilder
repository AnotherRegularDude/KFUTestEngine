json.extract! user, :id, :username
json.extract! user, :password if user.password.present?
json.extract! user, :first_name, :last_name, :patronymic, :fullname, :is_teacher
