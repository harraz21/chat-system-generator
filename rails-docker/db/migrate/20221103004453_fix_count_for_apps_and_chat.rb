class FixCountForAppsAndChat < ActiveRecord::Migration[5.0]
  def change
    rename_column :applications, :chat_count, :count
    rename_column :chats, :message_count, :count
  end
end
