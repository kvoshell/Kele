require 'httparty'


class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    @email = email
    @password = password
    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: { email: @email, password: @password })
    @auth_token = response["auth_token"]
    raise "Invalid token" if @auth_token == nil
    raise "Invalid email or password" unless response.code == 200
  end

  def get_me
    response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorization" => @auth_token})
    @user = JSON.parse(response.body)
  end
end
