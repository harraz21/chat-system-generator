class CreateMessageBodies < ActiveRecord::Migration[5.0]
  def change
    create_table :message_bodies do |t|
      t.string :message_key
      t.string :message_text

      t.timestamps
    end
    add_index :message_bodies, :message_key
  end
end
