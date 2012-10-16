Rhoconnect.configure do |config|
  config.token = "sometokenforme"
  # config.token = "c0ee9467198d4477b29203eab6c31611"

  config.uri   = "http://localhost:9292"
  # config.uri   = "http://sometokenforme@localhost:9292"
  #config.uri           = "http://sometokenforme@rhoconnect-resource.heroku.com"
  
  config.app_endpoint = "http://localhost:3000"
  #config.app_endpoint  = "http://rho-fat-free.heroku.com"

  config.authenticate = lambda { |credentials|
    user = User.find_by_username(credentials['login'])
    if user && user.valid_password?(credentials['password'])
      Rails.logger.info "Rhoconnect#authenticate: User #{credentials['login']} is successfully authenticated"
      return credentials['login']          
    end
                
    Rails.logger.error "Rhoconnect#authenticate: Invalid user credentials: #{credentials['login']}/#{credentials['password']}"
    return false
  }  
end
