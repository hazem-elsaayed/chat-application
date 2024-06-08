return if ENV['DISABLE_ES']
Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV.fetch("ES_HOST")