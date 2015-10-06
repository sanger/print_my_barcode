# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
       
LabelType.create(name: "Plate", pitch_length: "0110", print_width: "0920", print_length: "0080", feed_value: "08", fine_adjustment: "004")
LabelType.create(id: 2, name: "Tube", pitch_length: "0430", print_width: "0300", print_length: "0400", feed_value: "08", fine_adjustment: "022")
LabelType.create(id: 3,name: "Rack",pitch_length: "0110",print_width: "0920",print_length: "0080",feed_value: "08",fine_adjustment: "004")