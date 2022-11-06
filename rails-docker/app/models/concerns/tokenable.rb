require 'active_support/concern'
 
module Tokenable extend ActiveSupport::Concern
    included do
      before_create :generate_token
    end
  
    protected
  
    def generate_token
      self.token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false) # refactor this method :)
        while random_token.include? "_" || "-" || "!" || "?" || "*" || "#" || "[" || "]"
          random_token.each do |char|
            if char.include? ["_", "-", "!", "?", "*", "#", "[", "]"]
              random_token[char] = "&"
            end
          end
        end
        break random_token unless self.class.exists?(token: random_token)
      end
    end
end