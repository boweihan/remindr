class MessagesController < ApplicationController
  before_action :ensure_logged_in
  def index
    @messages = Message.all
  end
  #there probably doesn't need to be anything in here?
end
