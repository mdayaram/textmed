class PagesController < ApplicationController
  before_action :authenticate_user!

  def home
  	if !current_user.admin
  		sign_out
  	end
  	redirect_to admin_users_path
  end

  def inside
  	if !current_user.admin
  		sign_out
  	end
  	redirect_to admin_users_path
  end

end
