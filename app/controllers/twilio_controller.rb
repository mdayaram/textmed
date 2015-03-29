require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header
  skip_before_action :verify_authenticity_token

  def voice
    response = Twilio::TwiML::Response.new do |r|
      r.Dial :callerId => ENV["TWILIO_PHONE"] do |d|
        d.Number admin_user.phone_number
      end
    end
    render_twiml response
  end

  def sms
    sms_body = params["Body"]
    from_number = PhonyRails.normalize_number(params["From"])
    if from_number == admin_user.phone_number
      admin_msg(sms_body)
    else
      people_msg(from_number, sms_body)
    end
    render :text => ""
  end

  private

  def admin_msg(sms_body)
    to, body = sms_body.split(":", 2)
    user = User.where(:email => to).first
    if user.nil?
      send_sms(admin_user.phone_number, "User with email '#{to}' not found.")
      return
    end
    return unless !body.nil?

    message = Message.new do |m|
      m.user_id = user.id
      m.received = false
      m.body = body
    end

    message.save!
    send_sms(user.phone_number, body)
  end

  def people_msg(from_number, sms_body)
    user = User.where(:phone_number => from_number).first
    return unless !user.nil?

    message = Message.new do |m|
      m.user_id = user.id
      m.received = true
      m.body = sms_body
    end

    message.save!
    send_ack_msg(user, sms_body)
  end

  def admin_user
    User.where(:admin => true).order(:created_at => :asc).first
  end

  def send_ack_msg(user, msg)
    body = "#{user.name} replied: #{msg}"
    send_sms(admin_user.phone_number, body)
  end
end
