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
      raise ArgumentError.new('User id ' + user_id + ' does not exist.')
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


  # replace user for this assignment
  # replacement_id: replacement user id
  def replace_user(replacement_id)
    if !User.exists?(replacement_id)
      raise ArgumentError.new('User id ' + replacement_id.to_s + ' does not exist.')
    end

    if (user_id == replacement_id)
      raise ArgumentError.new('Cannot replace assignment with the same user.')
    end

    user = User.find(user_id)
    if (user.undoable_date)
      raise ArgumentError.new('User id ' + replacement_id.to_s + ' already has an undoable date on ' + user.undoable_date.to_s)
    end
    Assignment.transaction do
      user.undoable_date = date
      user.save!
      self.user_id = replacement_id
      self.save!
    end
  end

  # swap users with target assignment
  def swap_user(target_assignment_id)

    target = Assignment.find(target_assignment_id)
    if (!target)
      raise ArgumentError.new('Assignment ' + target_assignment_id + ' does not exist.')
    end

    if (user_id == target.user_id)
      raise ArgumentError.new('Cannot swap assignment with the same user.')
    end

    tmp = target.user_id
    Assignment.transaction do
      target.user_id = self.user_id
      target.save!
      self.user_id = tmp
      self.save!
    end

  end
end
