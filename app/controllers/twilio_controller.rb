require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def voice
    from_number = params["From"]
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hey there.  Congrats on integrating Twilio into your Rails app', :voice => 'alice'
      r.Play 'http://linode.rabasa.com/cantina.mp3'
    end
  end

  def sms
    sms_body = params["Body"]
    from_number = params["From"]
    $stderr.puts "\n\n\n\n\nPHONE: #{from_number}\n\n\n\n"
    user = User.where(:phone_number => from_number)
    if !user.nil?
      @message = Message.new do |m|
        m.user_id = user.id
        m.received = true
        m.body.body = sms_body
      end
      @message.save!
    end
  end
end
