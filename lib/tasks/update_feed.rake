desc "desc goes here"
task :refresh => :environment do
  Rails.logger.info "***************start"
  Worker.new.perform
  Rails.logger.info "hey"
end
