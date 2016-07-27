desc "Get Twitter Direct Messages"
task :get_twitter_dms => [:environment, :refresh] do
  puts "THEDIRECTMESSAGESAREADDED"
  Worker.new.dms
end
