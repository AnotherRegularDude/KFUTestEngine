class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.text :name
      t.text :short_description
      t.integer :questions_per_test

      t.timestamps
    end

    add_index(:topics, :name, unique: true)
  end
end
