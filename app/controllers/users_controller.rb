class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user,  only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, except: %i(new create index)

  def index
    @users = User.list.activated.order(:name).page(params[:page]).per Settings.page
  end

  def show
    redirect_to root_url and return unless @user.activated
    @microposts = @user.microposts.order_by_time.page(params[:page]).per Settings.page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controllers.users_controller.please_check"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "controllers.users_controller.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.users_controller.user_deleted"
    else
      flash[:danger] = t "controllers.users_controller.delete_unsuccessful"
    end
    redirect_to users_url
  end

  def following
    @title = t ".following"
    @users = @user.following.page(params[:page])
    render "show_follow"
  end

  def followers
    @title = t ".followers"
    @users = @user.followers.page(params[:page])
    render "show_follow"
  end

  private

  def load_user
    return if @user = User.find_by(id: params[:id])
    flash[:error] = t "controllers.users_controller.not_found"
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    store_location
    return if logged_in?
    flash[:danger] = t "controllers.users_controller.please_log"
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
