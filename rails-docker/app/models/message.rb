class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  before_destroy :delete_redis_key
  before_destroy :decremnet_count_in_chat

  settings do
      mappings dynamic: false do
        indexes :message_text, type: :text , analyzer: :english
        indexes :chat_key, type: :text , analyzer: :english
      end
  end

  def as_indexed_json(options = nil)
      self.as_json( only: [ :chat_key, :message_text ] )
  end

  def self.search_partial(search_word, key)
      self.search({
        query: {
          bool: {
            must: [
            {
              match: {message_text: search_word}
            }
            ] , 
            filter: [
              {term: { chat_key: key}}
            ]
          }
        }
      })
  end  

  def decremnet_count_in_chat
    if self.chat != nil
      Chat.transaction do
        chat = Chat.lock.find(self.chat)
        chat.message_count -= 1
        chat.save
      end 
    end
  end
  def delete_redis_key
    $redis.decr(self.chat_key)
  end

  belongs_to :chat
end
