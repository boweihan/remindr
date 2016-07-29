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

#DM id increase by time
