Rails.application.routes.draw do
	namespace :api, defaults: {format: :json} do
		get 'bootstrap' => 'bootstrap#index'

		resources :servers, except: [:new, :edit] do
			member do
				post :add_application
				post :remove_application
			end
		end
		resources :applications, except: [:new, :edit] do
			resources :images, except: [:new, :edit]
		end
	end

	get 'angular/view/*view' => 'public/welcome#view'

	root to: 'public/welcome#index'
end
