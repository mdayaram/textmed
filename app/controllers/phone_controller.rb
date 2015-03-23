class PhoneController < ApplicationController
  skip_before_action :verify_authenticity_token

  # temporary controller for testing.
  def sms
    u = User.find(params[:user])
    sms_body = params[:sms_body]
    @twiclient = Twilio::REST::Client.new
    @twiclient.messages.create(
      from: ENV["TWILIO_PHONE"],
      to: u.phone_number,
      body: sms_body
    )
    render text: "okay!"
  end
end
