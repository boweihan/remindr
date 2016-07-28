desc "Get Twitter Direct Messages"
task :get_twitter_dms => [:environment] do
  puts "THEDIRECTMESSAGESAREADDED"
  Worker.new.dms
end
