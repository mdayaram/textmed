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
    response = Twilio::TwiML::Response.new do |r|
      r.Message = 'Yay!'
    end
  end
end