class Hero < ActiveRecord::Base
  has_many :assignments, dependent: :destroy
  before_destroy :check_for_assignments
  attr_accessible :name, :undoable_date
  validates_uniqueness_of :name
  ActiveRecord::Base.include_root_in_json = false



  # XXX not calling...
  def check_for_assignments
    if assignments.count > 0
      raise ActiveRecord::DeleteRestrictionError.new("Cannot delete Hero " + id + " with assignments on the schedule.")
    end
  end



end
