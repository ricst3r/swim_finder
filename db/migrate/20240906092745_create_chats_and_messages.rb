class CreateChatsAndMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.timestamps
    end

    create_table :chats_users, id: false do |t|
      t.belongs_to :chat
      t.belongs_to :user
    end

    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.timestamps
    end
  end
end
