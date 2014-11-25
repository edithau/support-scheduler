# An assignment is a scheduled on-duty date of a user.
# Each assignment belongs to one user and only one unique assignment per day
# A cron job runs at mid-night everyday to remove out-of-date assignments. (see clock.rb)
# An assignment can only be replaced (undoable) but not removed (except out-of-date)
class Assignment < ActiveRecord::Base
  belongs_to :user
  default_scope order:  'date'
  validates :user_id, presence: true
  validates :date, presence: true
  ActiveRecord::Base.include_root_in_json = false


  # create a new assignment for the next available on-duty date.  An on-duty date is a weekday and not a california holiday
  def self.createAssignment(user_id)
    if User.exists?(user_id)
      if (Assignment.count > 0)
        last_date = Assignment.last.date
      else
        last_date = Date.today - 1
      end
      date = SupportCalendar.get_next_on_duty_date(last_date)
      self.create(user_id: user_id, date: date)
    else
      raise ArgumentError.new('User id ' + user_id.to_s + ' does not exist.')
    end

  end


  # today or first upcoming assignment
  def self.today
    Assignment.first
  end

  # all assignments for the target month
  def self.get_month(target_date)
    first_day_of_the_month = Date.new(target_date.year, target_date.month, 1)
    last_day_of_the_month = Date.new(target_date.year, target_date.month, -1)
    Assignment.where(date: first_day_of_the_month..last_day_of_the_month)
  end

  # swap users between 2 assignments
  def self.swap_user(id1, id2)

    assignment1 = Assignment.find(id1)
    assignment2 = Assignment.find(id2)

    if (assignment1.user_id == assignment2.user_id)
      raise ArgumentError.new("Cannot swap assignment with the same user.")
    end

    tmp = assignment1.user_id
    assignment1.user_id = assignment2.user_id
    assignment2.user_id = tmp
    Assignment.transaction do
      assignment1.save!
      assignment2.save!
    end

  end


  # replace user for this assignment
  # replacement_id: replacement user id
  def replace_user(replacement_id)
    if (self.user.undoable_date)
      raise ArgumentError.new('User id ' + replacement_id.to_s + ' already has an undoable date on ' + user.undoable_date.to_s)
    end

    if !User.exists?(replacement_id)
      raise ArgumentError.new('User id ' + replacement_id.to_s + ' does not exist.')
    end

    if (user_id == replacement_id)
      raise ArgumentError.new('Cannot replace assignment with the same user.')
    end

    replaced_user = self.user
    Assignment.transaction do
      replaced_user.undoable_date = date
      replaced_user.save!
      self.user_id = replacement_id
      self.save!
    end
  end
end
