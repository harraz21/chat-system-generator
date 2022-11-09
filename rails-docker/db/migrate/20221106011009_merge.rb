class Merge < ActiveRecord::Migration[5.0]
  def change
    add_column :messages , :message_text , :string
  end
end
