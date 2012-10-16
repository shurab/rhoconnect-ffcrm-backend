# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
class Account
  include Rhom::PropertyBag

  # Uncomment the following line to enable sync with Account.
  enable :sync

  #add model specifc code here
  set :partition, :app

  belongs_to :user_id, 'User'
  belongs_to :assigned_to, 'User'
end
