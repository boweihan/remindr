desc "desc goes here"
task :update_messages => :environment do
  Rails.logger.info "***************start"
  Worker.new.perform
  Rails.logger.info "hey"
end
