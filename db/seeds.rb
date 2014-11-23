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


Assignment.destroy_all
Hero.destroy_all

names.each do |name|
  hero = Hero.create(name: name)
  Assignment.createAssignment(hero.id)
end


Assignment.all.each do |assignment|
  puts assignment.hero.name
  puts assignment.date
end
