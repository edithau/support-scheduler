# A hero is a support team member.  Each hero has multiple assignments and
# up to one undoable date.  A hero can only be deleted if s/he has no assignments
class Hero < ActiveRecord::Base
  before_destroy :check_for_assignments
  has_many :assignments
  attr_accessible :name, :undoable_date
  ActiveRecord::Base.include_root_in_json = false


  def check_for_assignments
    if assignments.count > 0
      raise ActiveRecord::DeleteRestrictionError.new("Cannot delete Hero #{id} with assignments on the schedule.")
    end
  end



end
