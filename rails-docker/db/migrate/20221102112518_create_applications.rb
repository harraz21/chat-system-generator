class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :token
      t.integer :chatCount

      t.timestamps
    end
  end
end
