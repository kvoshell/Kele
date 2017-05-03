require 'httparty'
require './lib/roadmap.rb'


class Kele
  include HTTParty
  include Roadmap

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @email = email
    @password = password
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: { email: @email, password: @password })
    @auth_token = response["auth_token"]
    raise "Invalid token" if @auth_token == nil
    raise "Invalid email or password" unless response.code == 200
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })
    @user = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    @mentor_id = mentor_id
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{@mentor_id}/student_availability", values: { "id" => @mentor_id }, headers: { "authorization" => @auth_token })
    @availability = JSON.parse(response.body)
  end

  def get_messages(page = 'all')
    if page == 'all'
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token })
    else
      response = self.class.get("https://www.bloc.io/api/v1/message_threads/?page=#{page}", values: { "page" => page }, headers: { "authorization" => @auth_token })
    end
    @message = JSON.parse(response.body)
  end

  def create_message(sender_email, recipient_id, subject, stripped_text)
    response = self.class.post("https://www.bloc.io/api/v1/messages", body: { "sender" => sender_email, "recipient_id" => recipient_id, "subject" => subject, "stripped-text" => stripped_text }, headers: { "authorization" => @auth_token })
  end

  def create_submission(checkpoint_id, enrollment_id, assignment_branch = nil, assignment_commit_link = nil, comment = nil)
    response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions",
    body: {
      checkpoint_id: checkpoint_id,
      enrollment_id: enrollment_id,
      assignment_branch: assignment_branch,
      assignment_commit_link: assignment_commit_link,
      comment: comment
      },
    headers: { "authorization" => @auth_token })
  end
end
