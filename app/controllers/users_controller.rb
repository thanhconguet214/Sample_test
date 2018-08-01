class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.page(params[:page]).per Settings.number_page
  end

  def show
    @microposts = @user.microposts.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params   
    if @user.save
      @user.send_activation_email
      flash[:info] = t "controller.users.please"
      redirect_to root_url
    else
      render :new
    end
  end
 
  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controller.users.pro"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controller.users.del"
    else
      flash[:danger] = t "controller.users.not_del"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:success] = t "controller.users.error"
    redirect_to root_url  
  end

  def user_params
    params.require(:user).permit :name, :email, 
      :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
      flash[:danger] = t "controller.users.please"
      redirect_to login_url
  end

  def correct_user
    @user = User.find_by id: params[:id]
    return if current_user? @user
    flash[:danger] = t "controller.user.please"
    redirect_to root_url
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
