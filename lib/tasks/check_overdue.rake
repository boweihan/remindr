desc "Refresh the newsfeed"
task :find_overdue => [:environment, :refresh] do
  Worker.new.overdue
end
