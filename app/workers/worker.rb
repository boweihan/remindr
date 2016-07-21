class Worker
  def newsfeed
    Contact.update
  end

  def overdue
    User.check
  end
end
