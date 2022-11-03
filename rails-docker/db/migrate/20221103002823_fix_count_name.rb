class FixCountName < ActiveRecord::Migration[5.0]
  def change
    rename_column :applications, :chatCount, :chat_count
  end
end
