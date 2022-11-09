require 'elasticsearch'

module ElasticsearchUtils
    client = Elasticsearch::Client.new(url: 'http://localhost:9200')

    def self.extract_chats_result(results)
        messages = []
        results.first(10).each do |res|
            messages.append(res["_source"]["message_text"])
        end
        return messages
    end
end