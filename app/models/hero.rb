# A hero is a support team member.  Each hero has multiple assignments and
# up to one undoable date.  A hero can only be deleted if s/he has no assignments
class Hero < ActiveRecord::Base
  has_many :assignments, :dependent => :restrict
  attr_accessible :name, :undoable_date
  ActiveRecord::Base.include_root_in_json = false

  def get_assignments
    assignments
  end
end
