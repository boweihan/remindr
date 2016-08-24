desc "Refresh the newsfeed"
task :friendship_maker => [:environment, :refresh] do
  User.check_overdue_all_users
end
