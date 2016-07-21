desc "Refresh the newsfeed"
task :find_overdue => :environment do
  Rails.logger.info "***************start"
  Worker.new.overdue
  Rails.logger.info "hey"
end
