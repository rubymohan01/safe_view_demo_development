module ApplicationHelper
	def safeview_dashboard_path
    return root_path unless user_signed_in?

    if current_user.super_admin?
      user_dashboard_path
    elsif current_user.admin?
      root_path
    end
  end
end
