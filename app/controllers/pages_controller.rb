class PagesController < ApplicationController
  def home
    # @lists = List.all
  end

  def dashboard
    @userlists = List.where(user_id: current_user)
  end
end
