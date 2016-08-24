desc "Refresh the newsfeed"
task :refresh => :environment do
  Worker.new.newsfeed
end
