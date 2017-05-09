class CreateMaterials < ActiveRecord::Migration[5.1]
  def change
    create_table :materials do |t|
      t.text :short_description
      t.text :text_in_markdown
      t.belongs_to :topic, index: true

      t.timestamps
    end
  end
end
