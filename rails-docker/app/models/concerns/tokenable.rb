require 'active_support/concern'
 
module Tokenable extend ActiveSupport::Concern
    included do
      before_create :generate_token
    end
  
    protected
  
    REPLACED_CHAR = '$'

    def generate_token
      self.token = loop do
        random_token = SecureRandom.hex(16)
        break random_token unless !$redis.exists(random_token)
      end
    end
end

