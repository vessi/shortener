Rails.application.routes.draw do
  root to: 'index#index'
  post '/', to: 'index#short_url'
  get '/:short_url', to: 'index#unshort_url'
end
