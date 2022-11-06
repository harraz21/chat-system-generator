Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :applications, param: :token do
        resources :chats, param: :number do
          get 'search'
          resources :messages, param: :number do
          end
        end
      end
    end
  end
end