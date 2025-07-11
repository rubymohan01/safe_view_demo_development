class OrganizationInvitationsController < ApplicationController
  before_action :authenticate_user!, except: [:signup, :create_user_from_invite]

  def index
    @invitations = OrganizationInvitation.where(email: current_user.email)
  end

  def accept
    @invitation = OrganizationInvitation.find_by(token: params[:token])

    if @invitation.nil? || @invitation.email != current_user.email
      redirect_to root_path, alert: "Invalid or unauthorized invitation." and return
    end

    if @invitation.accepted.present?
      redirect_to root_path, alert: "Invitation already accepted." and return
    end

  end

  def confirm
    @invitation = OrganizationInvitation.find_by(token: params[:token])

    if @invitation.nil? || @invitation.email != current_user.email
      redirect_to root_path, alert: "Invalid or unauthorized invitation." and return
    end

    if current_user.organization_id.present?
      redirect_to root_path, alert: "You already belong to an organization." and return
    end

    current_user.update!(organization_id: @invitation.organization_id)

    redirect_to organization_path(@invitation.organization), notice: "You've joined #{@invitation.organization.name}!"
  end

  def signup
    @invitation = OrganizationInvitation.find_by(token: params[:token])

    if @invitation.nil? || @invitation.accepted.present?
      redirect_to root_path, alert: "Invalid or expired invitation." and return
    end

    sign_out(current_user) if user_signed_in?

    @user = User.new(email: @invitation.email)
  end


  def create_user_from_invite
    @invitation = OrganizationInvitation.find_by(token: params[:token])
    if @invitation.nil? || @invitation.accepted.present?
      redirect_to root_path, alert: "Invalid or expired invitation." and return
    end

    if User.exists?(email: @invitation.email)
      redirect_to new_user_session_path, alert: "An account with this email already exists. Please log in." and return
    end

    @user = User.new(user_params)
    @user.email = @invitation.email
    @user.organization_id = @invitation.organization_id

    policy = @invitation.organization.policy
    age = calculate_age(@user.date_of_birth)

    if policy&.min_age.present? && age < policy.min_age
      unless policy.parental_consent_required && params[:user][:parental_consent] == "1"
        flash.now[:alert] = "You must be at least #{policy.min_age} years old to join this organization, unless you have parental consent."
        render :signup, status: :unprocessable_entity and return
      end
    end

    if @user.save
      sign_in(@user)
      redirect_to organization_path(@invitation.organization), notice: "Account created and joined #{@invitation.organization.name}!"
    else
      render :signup, status: :unprocessable_entity
    end
  end

  private

  def calculate_age(birth_date)
    now = Time.zone.today
    now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
  end

  def user_params
    params.require(:user).permit(:name, :date_of_birth, :password, :password_confirmation)
  end
end
