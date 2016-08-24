desc "Get Twitter Direct Messages"
task :get_twitter_dms => [:environment] do
  Worker.new.dms
end
