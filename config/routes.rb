Estuary::Application.routes.draw do

# The root (/) goes straight to browsing for now. 
# Update this to offer an overview page instead.
root :to => 'posts#show'

get 'posts' => 'posts#show'

end
