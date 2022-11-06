class MessageBody < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings do
        mappings dynamic: false do
          indexes :message_text, type: :text , analyzer: :english
          indexes :message_key, type: :text , analyzer: :english
        end
    end

    def as_indexed_json(options = nil)
        self.as_json( only: [ :message_key, :message_text ] )
    end

    def self.search_partial(search_word, key)
        key = "#{key}".downcase
        self.search({
          query: {
            bool: {
              must: [
              {
                wildcard: {message_key: key} ,
              },
              {
                match: {message_text: "*#{search_word}*"}
              }
            ] 
            }
          }
        })
    end
end