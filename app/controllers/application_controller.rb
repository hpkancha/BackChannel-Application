class ApplicationController < ActionController::Base
  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to :log_in, :notice => "Please log in"
    end
  end
end
