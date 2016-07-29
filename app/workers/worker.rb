class Worker
  def newsfeed
    Contact.update
    Contact.update_reminders
  end

  def overdue
    User.check
  end

  def dms
    User.get_direct_messages
  end
end

#query after:2004/04/16 day-1 for email
