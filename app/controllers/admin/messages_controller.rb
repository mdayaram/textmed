class Admin::MessagesController < Admin::BaseController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = Message.all
  end

  def show
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        send_sms(@message.user.phone_number, @message.body)
        format.html { redirect_to admin_user_path(@message.user), notice: 'Message was successfully sent.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @message.body = message_params[:body]
    @message.user_id = message_params[:user_id]
    @message.received = message_params[:received]
    respond_to do |format|
      if @message.save
        format.html { redirect_to admin_message_path(@message), notice: "Saved" }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to admin_messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def message_params
    params.require(:message).permit(:user_id, :received, :body)
  end

  def send_sms(phone_number, sms_body)
    return unless Rails.env.production?
    twiclient = Twilio::REST::Client.new
    twiclient.messages.create(
      from: ENV["TWILIO_PHONE"],
      to: phone_number,
      body: sms_body
    )
  end
end
