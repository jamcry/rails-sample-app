class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
			@user.send_activation_email
			flash[:info] = "Successfully registered. "\
										 "Please check your email (#{@user.email}) "\
										 "to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    deleted_user_name = User.find(params[:id]).name
    User.find(params[:id]).destroy
    flash[:success] = "User (#{deleted_user_name}) deleted."
    redirect_to users_url
  end

  private

      def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
      end

      # Before fiters

      # Confirms a logged-in user
      def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "Please log in."
          redirect_to login_url
        end
      end

      # Confirms the correct user
      def correct_user
        @user = User.find(params[:id])
      
        unless current_user?(@user)
          flash[:warning] = "You are not authorized for this action."
          redirect_to(root_url)
        end
      end

      # Confirms an admin user
      def admin_user
        unless current_user.admin?
          flash[:warning] = "You must be an admin for this action!"
          redirect_to(root_url)
        end
      end
end
