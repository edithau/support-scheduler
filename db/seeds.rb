# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'date'
require 'holidays'

names = ['Sherry', 'Boris', 'Vicente']

names2 = ["Sherry", "Boris", "Vicente", "Matte", "Jack", "Sherry",
          "Matte", "Kevin", "Kevin", "Vicente", "Zoe", "Kevin",
          "Matte", "Zoe", "Jay", "Boris", "Eadon", "Sherry",
          "Franky", "Sherry", "Matte", "Franky", "Franky", "Kevin",
          "Boris", "Franky", "Vicente", "Luis", "Eadon", "Boris",
          "Kevin", "Matte", "Jay", "James", "Kevin", "Sherry",
          "Sherry", "Jack", "Sherry", "Jack"]


Hero.delete_all
Schedule.delete_all
start_date = Date.today

names.each do |name|
  hero = Hero.create(name: name)
  while (start_date.wday == 6 || start_date.wday == 0 || Holidays.on(start_date, :us_cali).any? ) do
    start_date = start_date + 1
  end
  schedule = Schedule.create(hero: hero, sdate: start_date)
  start_date = start_date + 1
end


Schedule.all.each do |schedule|
  puts schedule.hero.name
  puts schedule.sdate
end