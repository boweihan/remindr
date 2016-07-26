class Worker
  def newsfeed
    Contact.update
    Contact.update_reminders
  end

  def overdue
    User.check
  end
end
