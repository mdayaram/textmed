class PagesController < ApplicationController
  before_action :authenticate_user!, only: [
    :inside
  ]

  def home
  	redirect_to admin_users_path
  end

  def inside
  	redirect_to admin_users_path
  end

end
