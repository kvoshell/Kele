require 'httparty'

module Roadmap
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  # User Roadmap
  def get_roadmap(roadmap_id)
    @roadmap_id = roadmap_id
    response = self.class.get("https://www.bloc.io/api/v1/roadmaps/#{@roadmap_id}", headers: { "authorization" => @auth_token })
    @roadmap = JSON.parse(response.body)
  end

  # Roadmap specific checkpoint info
  def get_checkpoint(checkpoint_id)
    @checkpoint_id = checkpoint_id
    response = self.class.get("https://www.bloc.io/api/v1/checkpoints/#{@checkpoint_id}", headers: { "authorization" => @auth_token })
    @checkpoint = JSON.parse(response.body)
  end

  # Submit completed work
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
