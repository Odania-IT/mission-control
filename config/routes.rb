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
			resources :images, except: [:new, :edit], controller: 'application_images'
		end

		resources :repositories, except: [:new, :edit]
		resources :backup_servers, except: [:new, :edit]
		resources :background_schedules, except: [:new, :edit]
		resources :images, only: [:index]
		resources :templates, except: [:new, :edit]
	end

	namespace :protected do
		resources :servers, only: [:index, :show, :new, :edit]

		resources :applications, only: [:index, :show, :new, :edit] do
			collection do
				get :get_global_application
			end

			resources :images, only: [:index, :show, :new, :edit]
		end

		resources :repositories, only: [:index, :show, :new, :edit]
		resources :backup_servers, only: [:index, :show, :new, :edit]
		resources :background_schedules, only: [:index, :show, :new, :edit]
		resources :images, only: [:index, :show, :new, :edit]
		resources :templates, only: [:index, :show, :new, :edit]

		get '/application_log' => 'application_log#index'
	end

	root to: 'public/welcome#index'
end
