Rails.application.routes.draw do

  root 'main#show'

  concern :findable do
    member do
      get :except
      get :intersect
    end
  end

  namespace :api do
    namespace :v1 do
      resources :vacancies
      resources :employees
      resources :skills
    end

    namespace :v2 do
      resources :vacancies, only: :index, concerns: :findable
      resources :employees, only: :index, concerns: :findable
    end
  end

end
