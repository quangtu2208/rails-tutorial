class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = t "controllers.sessions_controller.account_not_activated"
        message += t "controllers.sessions_controller.check_your_email"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash[:danger] = t "controllers.sessions_controller.invalid_email"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
