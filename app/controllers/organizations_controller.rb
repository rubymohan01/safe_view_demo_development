class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: %i[show edit update destroy create_invite]
  before_action :require_admin, only: [:edit, :update, :destroy]

  def index
    @organizations = current_user.super_admin? ? Organization.all : current_user.organizations
  end

  def new
    @organization = Organization.new
    @organization.build_policy
  end

	def create
    @organization = Organization.new(organization_params)
    @organization.status = :pending

    admin_ids = params[:organization][:admin_user_ids].to_a.reject(&:blank?)

    if admin_ids.empty?
      flash[:alert] = "You must select at least one admin."
      @organization.build_policy unless @organization.policy
      render :new, status: :unprocessable_entity and return
    end

    if @organization.save
      admin_ids.each do |user_id|
        @organization.memberships.create(user_id: user_id, role: :admin)
      end
      redirect_to @organization, notice: 'Organization created successfully.'
    else
      @organization.build_policy unless @organization.policy
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @organization.build_policy unless @organization.policy
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_path, notice: 'Organization was successfully deleted.'
  end

  def activate
	  @organization = Organization.find(params[:id])
	  @organization.update(status: :active)
	  redirect_to @organization, notice: "Organization activated."
	end

  def search_and_invite
    @user_to_invite = User.find_by(email: params[:search_email]) if params[:search_email].present?
    render :show
  end

  def show
    @organization = Organization.find(params[:id])
    @last_invitation = OrganizationInvitation.find_by(id: params[:last_invite_id]) if params[:last_invite_id].present?
  end


  def create_invite
    organization = Organization.find(params[:id])
    email = params[:email].downcase.strip

    invite = OrganizationInvitation.find_or_initialize_by(organization: organization, email: email)

    if invite.persisted?
      redirect_to organization_path(organization), alert: "User has already been invited to this organization." and return
    end

    invite.user_id = current_user.id
    invite.token = SecureRandom.hex(20)
    invite.accepted = false

    if invite.save
      redirect_to organization_path(organization), notice: "Invitation created! Sign-up link: #{organization_invite_signup_url(token: invite.token)}"
    else
      redirect_to organization_path(organization), alert: "Failed to create invite: #{invite.errors.full_messages.to_sentence}"
    end
  end


  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(
      :name, :description, admin_user_ids: [],
      policy_attributes: [:id, :min_age, :parental_consent_required]
    )
  end

  def require_admin
    unless current_user&.admin? || current_user&.super_admin?
      redirect_to root_path, alert: "Access denied"
    end
  end
end
