class RenameColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :applications, :count, :chat_count
    rename_column :chats, :count, :message_count
  end
end
