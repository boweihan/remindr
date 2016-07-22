class Worker
  def newsfeed
    Contact.update
    Contact.generate_reminder
  end

  def overdue
    User.check
  end
end
