require 'elasticsearch'

module ElasticsearchUtils
    client = Elasticsearch::Client.new(url: 'http://localhost:9200')
end