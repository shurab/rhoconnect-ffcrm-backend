require 'json'
require 'rest_client'

class Account < SourceAdapter
  def initialize(source)
    @url = "http://localhost:3000/rhoconnect"
    super(source)
  end
 
  def login
    # puts "***** Account#login"
    # TODO: Login to your data source here if necessary
  end
 
  def query(params=nil)
    puts 
    puts "***** Account#query -- start"
        
    url = "#{@url}/query"
    headers = { :content_type => :json, :accept => :json }
    #
    # Partitioning data per user
    # body = {:resource => "Account",
    #   :partition => current_user.login, :api_token => Rhoconnect.api_token,
    #   :attributes => { :offset => 0, :limit => 25 } 
    # }
        
    #
    # Partitioning data per application
    body = {:resource => "Account",
      :partition => :app, :api_token => Rhoconnect.api_token,
      :attributes => { :offset => 0, :limit => 25 } 
    }
    puts "current_user: #{current_user.login}"
    puts "url: #{url}"
    puts "headers: #{headers}" 
    puts "body: #{body.to_json}"
    
    puts "Paginate through backend Account data ..."
    offset, page_sz = 0, 25
    loop do
      # puts "body: #{body}"
      rest_result = RestClient.post(url, body.to_json, headers).body
      raise SourceAdapterException.new("Error connecting to Fat-Free-CRM backend!") if rest_result.code != 200
      
      @result ||= {}
      puts "@result size: #{@result.size}"
      @result.merge!(JSON.parse(rest_result))
      rec_num = @result.size 
      puts "Got #{rec_num} records"
      stash_result
      # After stash_result @result is nil
      puts "@result is nil: #{@result.nil?}"
      break if rec_num < page_sz
      offset += page_sz
      body[:attributes][:offset] = offset
    end

    #
    # Traditional way to get all backend data in one query
    #
    # rest_result = RestClient.post(url, body.to_json, headers).body
    # raise SourceAdapterException.new("Error connecting to Fat-Free-CRM backend!") if rest_result.code != 200
    # @result = JSON.parse(rest_result)
    # @result = { 
    #   "62" => { "name"=>"Barrows-Gerhold", category"=>"reseller",  ... },
    #   "74" => { "name"=>"Schneider, Cremin and Armstrong", "category"=>"competitor" , ... }
    #   ... 
    # }
    #

    puts "***** Account#query -- end"
    puts         
  rescue Exception => e  
    puts e.message
    puts e.backtrace.inspect  
  end
 
  def sync
    # Manipulate @result before it is saved, or save it 
    # yourself using the Rhoconnect::Store interface.
    # By default, super is called below which simply saves @result
    super
  end
 
  def create(create_hash)
    # TODO: Create a new record in your backend data source
    url = "#{@url}/create"
    headers = { :content_type => :json, :accept => :json }
    body = {:resource => "Account",
      :partition => current_user.login, :api_token => Rhoconnect.api_token,
      :attributes => create_hash
    }
    # puts headers
    # puts body    
    res = RestClient.post(url, body.to_json, headers)
    # puts "***** Account#create: res=#{res}"
    raise SourceAdapterException.new("Error creating new record #{create_hash.inspect}") if res.code != 200        
    res.body
  end
 
  def update(update_hash)
    # TODO: Update an existing record in your backend data source
    url = "#{@url}/update"
    headers = { :content_type => :json, :accept => :json }
    body = {:resource => "Account",
      :partition => current_user.login, :api_token => Rhoconnect.api_token,
      :attributes => update_hash
    }

    raise ArgumentError.new("Missing object id for #{update_hash.inspect}") unless update_hash.has_key?('id')     
    rest_result = RestClient.post(url, body.to_json, headers).body
    raise SourceAdapterException.new("Error updating record for #{update_hash.inspect}") if rest_result.code != 200    
  end
 
  def delete(delete_hash)
    # TODO: write some code here if applicable
    # be sure to have a hash key and value for "object"
    # for now, we'll say that its OK to not have a delete operation
    # raise "Please provide some code to delete a single object in the backend application using the object_id"
    url = "#{@url}/delete"
    headers = { :content_type => :json, :accept => :json }
    body = {:resource => "Account",
      :partition => current_user.login, :api_token => Rhoconnect.api_token,
      :attributes => delete_hash
    }
    # TODO: dependencies 
    raise ArgumentError.new("Missing object id for #{delete_hash.inspect}") unless delete_hash.has_key?('id')     
    rest_result = RestClient.post(url, body.to_json, headers).body
    raise SourceAdapterException.new("Error deleting record for #{delete_hash.inspect}") if rest_result.code != 200
  end
 
  def logoff
    # TODO: Logout from the data source if necessary
    # puts "***** Account#logoff"
  end
end
