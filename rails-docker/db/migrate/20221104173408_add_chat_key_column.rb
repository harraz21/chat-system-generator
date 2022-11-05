class AddChatKeyColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :chat_key, :string
  end
end
