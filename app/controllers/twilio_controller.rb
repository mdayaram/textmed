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
    render :text => ""
  end

  def sms
    sms_body = params["Body"]
    from_number = PhonyRails.normalize_number(params["From"])
    user = User.where(:phone_number => from_number).first
    if !user.nil?
      @message = Message.new do |m|
        m.user_id = user.id
        m.received = true
        m.body = sms_body
      end
      @message.save!
    end
    send_ack_msg(user, sms_body)
    render :text => ""
  end

  private

  def admin_user
    User.where(:admin => true).order(:created_at => :asc).first
  end

  def send_ack_msg(user, msg)
    body = "#{user.name} replied: #{msg}"
    send_sms(admin_user.phone_number, body)
  end
end
