require 'httparty'
require './lib/roadmap.rb'


class Kele
  include HTTParty
  include Roadmap

  base_uri 'https://www.bloc.io/api/v1'

  # Login via API
  def initialize(email, password)
    @email = email
    @password = password
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: { email: @email, password: @password })
    @auth_token = response["auth_token"]
    raise "Invalid token" if @auth_token == nil
    raise "Invalid email or password" unless response.code == 200
  end

  # Entire User File
  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })
    @user = JSON.parse(response.body)
  end

  # Mentor schedule
  def get_mentor_availability(mentor_id)
    @mentor_id = mentor_id
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{@mentor_id}/student_availability", values: { "id" => @mentor_id }, headers: { "authorization" => @auth_token })
    @availability = JSON.parse(response.body)
  end

  # Retrieve personal messages
  def get_messages(page = 'all')
    if page == 'all'
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token })
    else
      response = self.class.get("https://www.bloc.io/api/v1/message_threads/?page=#{page}", values: { "page" => page }, headers: { "authorization" => @auth_token })
    end
    @message = JSON.parse(response.body)
  end

  # Create message
  def create_message(sender_email, recipient_id, subject, stripped_text)
    response = self.class.post("https://www.bloc.io/api/v1/messages", body: { "sender" => sender_email, "recipient_id" => recipient_id, "subject" => subject, "stripped-text" => stripped_text }, headers: { "authorization" => @auth_token })
  end

  
end
