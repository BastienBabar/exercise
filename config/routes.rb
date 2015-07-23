Rails.application.routes.draw do
  scope '/api' do
    post '/' => 'application#create'
    get '/' => 'application#show'
    put '/' => 'application#update'
    put '/delete' => 'application#destroy'
  end
end
