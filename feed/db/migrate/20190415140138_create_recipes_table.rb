class CreateRecipesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
