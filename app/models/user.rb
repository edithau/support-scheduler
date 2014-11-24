# A user is a support team member.  Each user has multiple assignments and
# up to one undoable date.  A user can only be deleted if s/he has no assignments
class User < ActiveRecord::Base
  has_many :assignments, :dependent => :restrict
  attr_accessible :name, :undoable_date
  ActiveRecord::Base.include_root_in_json = false

  def get_assignments
    assignments
  end
end
