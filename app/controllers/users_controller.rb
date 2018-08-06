class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.page(params[:page]).per Settings.number_page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params   
    if @user.save
      log_in @user
      flash[:success] = t ".fl"
      redirect_to @user
    else
      render :new
    end
  end
 
  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".pro"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".del"
    else
      flash[:danger] = t ".not_del"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:success] = t ".error"
    redirect_to root_url  
  end

  def user_params
    params.require(:user).permit :name, :email, 
      :password, :password_confirmation
  end
end
