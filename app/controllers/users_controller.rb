class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_super_admin!

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User deleted."
  end

  def dashboard
    if current_user.organization_id.nil?
      @invitations = OrganizationInvitation.where(email: current_user.email, accepted_at: nil)
    end

    @organization = current_user.organization
    @channels = @organization.channels if @organization
  end

   private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :date_of_birth, :role, :organization_id, :password, :password_confirmation)
  end

  def require_super_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.super_admin?
  end
end
