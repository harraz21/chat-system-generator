class Application < ApplicationRecord
    include Tokenable

    before_create :set_default_count
    after_create :store_count_in_redis
    before_destroy :delete_redis_key

    def delete_redis_key
        $redis.del(self.token)
    end

    def set_default_count
        self.chat_count = 0
    end

    def store_count_in_redis
        $redis.set(self.token, self.chat_count)
    end

    validates :name, presence: true
    has_many :chat , dependent: :destroy
end
