class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account successfully activated!"
      redirect_to user
    elsif user && user.activated?
      flash[:info] = "The user is already activated."
      redirect_to root_url
    else
      flash[:danger] = "Invalid activation link!"
      redirect_to root_url
    end
  end
end
