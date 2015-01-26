Rails.application.routes.draw do
	namespace :protected do
		resources :servers
	end

	root to: 'public/welcome#index'
end
