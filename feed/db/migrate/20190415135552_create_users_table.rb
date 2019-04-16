class CreateUsersTable < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      # add last name column
      t.timestamps
    end
  end
end
