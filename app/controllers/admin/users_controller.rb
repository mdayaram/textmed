class Admin::UsersController < Admin::BaseController

  before_action :set_user, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]


  def index
    @users = User.search_and_order(params[:search])
    @users = @users.sort_by { |u| u.last_message_date! }
  end

  def new
    @user = User.new
    # Stub info for user that we're not currently using right now.
    @user.password = "1234"
    @user.password_confirmation = "1234"
    @user.admin = false
    @user.locked = false
  end

  def create
    @user = User.new(user_params)
    @user.skip_confirmation!
    format_number(@user)
    respond_to do |format|
      if @user.save
        format.html { redirect_to admin_users_path, notice: "#{@user.name} was successfully added." }
      else
        format.html { render :new }
      end
    end
  end

  def show
    @message = Message.new
  end

  def destroy
    @user.messages.each do |m|
      m.destroy
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: "User #{@user.name} and all associated messages have been deleted."}
    end
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

  def format_number(u)
    if u.phone_number.length == 10
      u.phone_number = "+1" + u.phone_number
    end
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
