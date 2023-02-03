class ApplicationController < ActionController::API
  def browser
    @browser ||= Browser.new(request.user_agent)
  end
end
