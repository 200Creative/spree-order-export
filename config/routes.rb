Rails.application.routes.draw do
  # Add your extension routes here
  Spree::Core::Engine.routes.prepend do
    namespace :admin do
      resources :reports do
        get 'order_export', :on => :collection
      end
    end
  end
end
