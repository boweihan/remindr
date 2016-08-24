class Worker
  def newsfeed
    Contact.update
    Contact.update_reminders
  end

  def overdue
    User.check_overdue_all_users
  end

  def dms
    User.get_direct_messages_all_users
  end
end
