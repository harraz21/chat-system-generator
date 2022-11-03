class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.integer :number
      t.integer :message_count
      t.references :application, foreign_key: true

      t.timestamps
    end
  end
end
