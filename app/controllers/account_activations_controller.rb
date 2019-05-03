class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by email: params[:email]

    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "controllers.account_activation.account_activated"
      redirect_to user
    else
      flash[:danger] = t "controllers.account_activation.invalid_activation_link"
      redirect_to root_url
    end
  end
end
