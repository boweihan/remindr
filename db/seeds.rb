# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Contact.create(name: 'Ella', phone: '9999999999', email: 'ella@bitmaker.co', user_id:1)
Contact.create(name: 'Erik', phone: '9999999999', email: 'erik@bitmakerlabs.com' ,user_id:1)
Contact.create(name: 'Erik Invoices', phone: '9999999999', email: 'erik@bitmaker.co',user_id:1)
Contact.create(name: 'Adrian', phone: '9999999999', email: 'adrian@bitmakerlabs.com',user_id:1)
Contact.create(name: 'Adrian', phone: '9999999999', email: 'bad',user_id:1)
Contact.create(name: 'Adrian', phone: '9999999999', user_id:1)

User.create(name: 'test', phone: 'test', email: 'test@test.com', password: 'test', password_confirmation: 'test')
