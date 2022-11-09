class Chat < ApplicationRecord
  belongs_to :application
  before_destroy :delete_redis_key
  before_destroy :decremnet_count_in_application
  def delete_redis_key
    if self.application != nil
      $redis.decr(self.application.token)
    end
    $redis.del(self.chat_key)
  end


  def decremnet_count_in_application
    if self.application != nil
      Application.transaction do
        application = Application.lock.find(self.application)
        application.chat_count -= 1
        application.save
      end 
    end
  end

  has_many :messages, dependent: :destroy
end
