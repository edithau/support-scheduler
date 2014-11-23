# An assignment is a scheduled on-duty date of a hero (resource)
# Each assignment belongs to one hero and only one unique assignment per day
# A cron job runs at mid-night everyday to remove out-of-date assignments.
# An assignment can only be replaced (undoable) but not removed (except out-of-date)
class Assignment < ActiveRecord::Base
  belongs_to :hero
  default_scope order:  'date'
  validates :hero_id, presence: true
  validates :date, presence: true
  validates_uniqueness_of :date
  ActiveRecord::Base.include_root_in_json = false


  # create a new assignment for the next available on-duty date.  An on-duty date is a weekday and not a california holiday
  def self.createAssignment(hero_id)
    if Hero.exists?(hero_id)
      if (Assignment.count > 0)
        last_date = Assignment.last.date
      else
        last_date = Date.today
      end
      date = SupportCalendar.get_next_on_duty_date(last_date)
      self.create(hero_id: hero_id, date: date)
    else
      raise ArgumentError.new('Hero id ' + hero_id + ' does not exist.')
    end

  end

  # swap assignments
  def self.swap(id1, id2)
    begin
      assignment1 = Assignment.find(id1)
      assignment2 = Assignment.find(id2)

      tmp = assignment1.hero_id
      assignment1.hero_id = assignment2.hero_id
      assignment2.hero_id = tmp
      Assignment.transaction do
        assignment1.save
        assignment2.save
      end
    ensure
      if assignment1
        assignment1.reload
      end
      if assignment2
        assignment2.reload
      end
    end

  end

  # today or upcoming assignment
  def self.today
    Assignment.first
  end

  # all assignments for the current month
  def self.current_month
    today = Date.today
    last_day_of_the_month = Date.new(today.year, today.month, -1)
    Assignment.where(date: today..last_day_of_the_month)
  end


  # replace hero for this assignment
  # replacement_id: replacement hero id
  def replace_hero(replacement_id)
    if Hero.exists?(replacement_id)
      hero = Hero.find(hero_id)
      if (!hero.undoable_date)
        hero.undoable_date = date
        hero.save
        self.hero_id = replacement_id
        self.save
        self.reload
      else
        raise ArgumentError.new('Hero id ' + replacement_id.to_s + ' already has an undoable date on ' + hero.undoable_date.to_s)
      end
    else
      raise ArgumentError.new('Hero id ' + replacement_id.to_s + ' does not exist.')
    end
  end
end
