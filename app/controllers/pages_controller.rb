class PagesController < ApplicationController
  def newsfeed
    #write the loop to grab all the messages of all the contacts with current user

    puts current_user.id
    puts Contact.all
    puts Message.all

    @messages = Array.new
    @contacts = Array.new
    current_user.messages.each do |message|
      @contacts << Contact.find(message.contact_id)
      @messages << message
    end

  end
end
