# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class User
  include Rhom::PropertyBag

  # Uncomment the following line to enable sync with User.
  enable :sync

  #add model specifc code here
  set :partition, :app

  def full_name
    self.first_name.empty? && self.last_name.empty? ? self.email : "#{self.first_name} #{self.last_name}".strip     
  end 
end
