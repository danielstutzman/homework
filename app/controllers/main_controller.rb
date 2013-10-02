class MainController < ApplicationController
  def root
  end

  def login_from_github
    hash = request.env['omniauth.auth']
    raise hash.info.nickname.inspect
  end
end
