desc "Refresh the newsfeed"
task :refresh => :environment do
  User.update_newsfeed_all_users
  User.update_reminders_all_contacts
end
