desc "Refresh the newsfeed"
task :find_overdue => :environment do
  Rails.logger.info "***************start"
  Worker.new.perform
  Rails.logger.info "hey"
end
