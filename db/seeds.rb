# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Bowei's seeds


# Contact.create(name: 'Ella', phone: '9999999999', email: 'ella@bitmaker.co', user_id:1, category: 'business')
# Contact.create(name: 'Erik', phone: '9999999999', email: 'erik@bitmakerlabs.com' ,user_id:1, category: 'business')
# Contact.create(name: 'Erik Invoices', phone: '9999999999', email: 'erik@bitmaker.co',user_id:1, category: 'business', twitter_username: '')
# Contact.create(name: 'Adrian', phone: '9999999999', email: 'adrian@bitmakerlabs.com',user_id:1, category: 'family')
# Contact.create(name: 'Adrian', phone: '9999999999', email: 'bad',user_id:1, category: 'family')
# Contact.create(name: 'Adrian', phone: '9999999999', user_id:1, category: 'family')




#Jon's seeds
User.create(name: 'test', phone: 'test', email: 'test@test.com', password: 'test', password_confirmation: 'test', reminder_platform: "Email")

Contact.create(name: 'Codecademy', phone: '9999999999', email: 'contact@codecademy.com', user_id:1, category: 'friend')
Contact.create(name: 'Google', phone: '9999999999', email: 'no-reply@accounts.google.com' ,user_id:1, category: 'business')
Contact.create(name: 'Random', phone: '9999999999', email: 'random@random.com',user_id:1, category: 'family')
Contact.create(name: 'Person With no Email', phone: '9999999999',user_id:1, category: 'friend')
Contact.create(name: 'Uber', phone: '9999999999', email:"receipts@uber.com", user_id:1, category: 'business')
Contact.create(name: 'Uber Eats', phone: '9999999999', email:"receipts@uber.com", user_id:1, category: 'family')
Contact.create(name: 'Uber Dogs', phone: '9999999999', email:"receipts@uber.com", user_id:1, category: 'friend')

#Carol's seeds to seed

Contact.create(name: 'Bowei', phone: '9999999999', email:"bowei.han100@gmail.com", user_id:1, category: 'friend',  twitter_username: 'BoweiHan')
