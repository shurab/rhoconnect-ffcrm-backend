class Application < Rhoconnect::Base
  class << self
    
    # This method will never been called if you are using RhoConnect Plugin.
    # Instead, rhoconnect will use Backend App URL and call authenticate method
    # defined in plugin configuration. 
    #
    # Actually, it will do for you the following:
    #   hash = {:login => username, :password => password, :api_token => Rhoconnect.api_token}.to_json
    #   headers = {:content_type => :json, :accept => :json}
    #   RestClient.post "#{Rhoconnect.appserver}/rhoconnect/authenticate", hash, headers
    #
    def authenticate(username, password, session)
      return true
    end

    def ans_authenticate(username,password)
      puts "Application#ans_authenticate:: username: #{username}, password: #{password}"
      true # optionally handle rhoconnect push authentication...
    end
    
    # Add hooks for application startup here
    # Don't forget to call super at the end!
    def initializer(path)
      super
    end
    
    # Calling super here returns rack tempfile path:
    # i.e. /var/folders/J4/J4wGJ-r6H7S313GEZ-Xx5E+++TI
    # Note: This tempfile is removed when server stops or crashes...
    # See http://rack.rubyforge.org/doc/Multipart.html for more info
    # 
    # Override this by creating a copy of the file somewhere
    # and returning the path to that file (then don't call super!):
    # i.e. /mnt/myimages/soccer.png
    def store_blob(object,field_name,blob)
      super #=> returns blob[:tempfile]
    end
  end
end

Application.initializer(ROOT_PATH)

# Support passenger smart spawning/fork mode:
if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      # We're in smart spawning mode.
      Store.db.client.reconnect
    else
      # We're in conservative spawning mode. We don't need to do anything.
    end
  end
end
