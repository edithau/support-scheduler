class Assignment < ActiveRecord::Base
  belongs_to :hero
  default_scope order:  'sdate'
  validates :hero_id, presence: true
  validates :sdate, presence: true
  validates_uniqueness_of :sdate
  ActiveRecord::Base.include_root_in_json = false


  # create a new assignment for the next available on-duty date
  def self.createAssignment(hero_id)
    if Hero.exists?(hero_id)
      if (Assignment.count > 0)
        last_sdate = Assignment.last.sdate
      else
        last_sdate = Date.today
      end
      sdate = SupportCalendar.get_next_on_duty_date(last_sdate)
      self.create(hero_id: hero_id, sdate: sdate)
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


  # replace hero for this assignment
  def replace_hero(replacement_id)
    if Hero.exists?(replacement_id)
      hero = Hero.find(hero_id)
      if (!hero.undoable_date)
        hero.undoable_date = sdate
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
