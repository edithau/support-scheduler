require 'date'
require 'holidays'

#names = ['Sherry', 'Boris', 'Vicente']


Assignment.destroy_all
User.destroy_all

names = File.read('./db/names.txt')
names = names.split(/\n/)
names.each do |name|
  user = User.find_or_create_by_name(name)
  Assignment.createAssignment(user.id)
end


Assignment.all.each do |assignment|
  puts assignment.user.name
  puts assignment.date
end
