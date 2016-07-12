class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end
  #there probably doesn't need to be anything in here?
end
