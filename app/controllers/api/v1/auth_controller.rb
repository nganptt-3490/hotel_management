class Api::V1::AuthController < Api::V1::ApplicationController
  def create
    @user = User.find_by email: params[:email]&.downcase

    if @user&.valid_password? params[:password]
      @token = encode_token(user_id: @user.id)
      render json: {
        user: UserSerializer.new(@user),
        token: @token,
        message: "Log in success"
      }, status: :accepted
    else
      render json: {message: "Invalid email or password"}, status:
      :unprocessable_entity
    end
  end
end
