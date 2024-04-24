class Users::SessionsController < Devise::SessionsController
  respond_to :json
  private
  def respond_with(current_user, _opts = {})
    render json: current_user, status: :ok
  end
  def respond_to_on_destroy
    render json: { message: "Logged out." }
  end
end