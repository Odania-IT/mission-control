Rails.application.routes.draw do
	namespace :api, defaults: {format: :json} do
		get 'bootstrap' => 'bootstrap#index'

		resources :servers, except: [:new, :edit] do
			member do
				post :add_application
				post :remove_application
			end

			resources :containers, only: [:update]
		end
		resources :applications, except: [:new, :edit] do
			collection do
				get :get_global_application
			end

			resources :images, except: [:new, :edit]
		end

		resources :repositories
		resources :backup_servers
	end

	get 'angular/view/*view' => 'public/welcome#view'

	root to: 'public/welcome#index'
end
