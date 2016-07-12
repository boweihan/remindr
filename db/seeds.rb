# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Contact.create(name: 'bowei', phone: '9999999999', email: 'bowei@bowei.com', user_id:2)
Contact.create(name: 'bowei2', phone: '9999999999', email: 'bowei2@bowei.com',user_id:2)
Contact.create(name: 'bowei3', phone: '9999999999', email: 'bowei3@bowei.com',user_id:2)
Contact.create(name: 'bowei3', phone: '9999999999', email: 'bowei4@bowei.com',user_id:2)
User.create(name: 'bowei', phone: '888888888', email: 'bowei@user.com', password: 'password', password_confirmation: 'password')
User.create(name: 'bowei', phone: '888888888', email: 'bowei2@user.com', password: 'password', password_confirmation: 'password')
Message.create(contact_id:1, user_id:2)
Message.create(contact_id:1, user_id:2)
Message.create(contact_id:1, user_id:2)
Message.create(contact_id:1, user_id:2)
Message.create(contact_id:1, user_id:2)
