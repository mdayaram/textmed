class PhoneController < ApplicationController

  def sms
    u = User.find(param[:user])
    sms_body = param[:sms_body]
    @twiclient = Twilio::REST::Client.new
    @twiclient.messages.create(
      from: ENV["TWILIO_PHONE"],
      to: u.phone_number,
      body: sms_body
    )
  end
end
