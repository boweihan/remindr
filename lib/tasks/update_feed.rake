desc "Refresh the newsfeed"
task :refresh => :environment do
  puts "THETASKISRUNNING"
  Worker.new.newsfeed
end
