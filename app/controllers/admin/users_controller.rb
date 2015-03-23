class Admin::UsersController < Admin::BaseController

  before_action :set_user, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]


  def index
    @users = User.search_and_order(params[:search], params[:page])
  end

  def show
  end

  def edit
  end

  def update
    old_email = @user.email
    new_params = user_params.dup
    new_params[:email] = new_params[:email].strip unless new_params[:email].nil?

    @user.email = new_params[:email]
    @user.name = new_params[:name].strip unless new_params[:name].nil?
    @user.phone_number = new_params[:phone_number].strip unless new_params[:phone_number].nil?

    if current_user.id != @user.id
      @user.admin = new_params[:admin].to_i != 0
      @user.locked = new_params[:locked].to_i != 0
    end

    if @user.valid?
      @user.skip_reconfirmation!
      @user.save
      redirect_to admin_users_path, notice: "#{@user.email} updated."
    else
      flash[:alert] = "#{old_email} couldn't be updated."
      render :edit
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  rescue
    flash[:alert] = "The user with an id of #{params[:id]} doesn't exist."
    redirect_to admin_users_path
  end

  def user_params
    params.require(:user).permit(
      :name,
      :phone_number,
      :email,
      :password,
      :password_confirmation,
      :admin,
      :locked
    )
  end

end
