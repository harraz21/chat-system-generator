class AddChatKeyToChat < ActiveRecord::Migration[5.0]
  def change
    add_index :applications , :token , unique: true
    add_column :chats , :chat_key , :string
    add_index :chats , :chat_key , unique: true
  end
end
