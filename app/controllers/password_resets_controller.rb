class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase 
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "controller.password_resets.email.sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "controller.password_resets.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.error.add :password, t("controller.password_resets.error_update")
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "controller.password_resets.success_update"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated? :reset, params[:id]
    flash[:success] = t "controller.password_resets.note"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "controller.password_resets.check_expiration"
    redirect_to new_password_reset_url
  end
end
