require 'csv'

class Admin::MessagesController < Admin::BaseController

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

  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to admin_messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def index
    filename = Time.now.strftime("%Y-%m-%dT%H-%M-%S_messages.csv")
    @messages = Message.all
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
        headers['Content-Type'] ||= 'text/csv'
      end
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

end
