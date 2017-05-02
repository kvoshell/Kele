require 'httparty'

module Roadmap
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def get_roadmap(roadmap_id)
    @roadmap_id = roadmap_id
    response = self.class.get("https://www.bloc.io/api/v1/roadmaps/#{@roadmap_id}", headers: { "authorization" => @auth_token })
    @roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    @checkpoint_id = checkpoint_id
    response = self.class.get("https://www.bloc.io/api/v1/checkpoints/#{@checkpoint_id}", headers: { "authorization" => @auth_token })
    @checkpoint = JSON.parse(response.body)
  end
end
