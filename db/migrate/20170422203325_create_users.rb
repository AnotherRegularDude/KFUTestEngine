class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.text :username
      t.text :password_digest
      t.text :first_name
      t.text :second_name
      t.text :patronymic
      t.boolean :is_teacher
    end

    add_index(:users, :username, unique: true)
  end
end
