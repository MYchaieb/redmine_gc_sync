# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
# get 'livrable_project', :to => 'livrable_project#index'
# post 'post/:id/update', :to => 'livrable_project#update'

resources :livrable_project do 

	post 'update_livrable_date', :on => :collection
	post 'delete_event', :on => :collection
	post 'save_or_update_title', :on => :collection
	
end