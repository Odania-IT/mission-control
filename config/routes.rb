Rails.application.routes.draw do
	namespace :protected do
		resources :servers
		resources :applications
		resources :images
	end

	root to: 'public/welcome#index'
end
