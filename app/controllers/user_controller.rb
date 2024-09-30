class UserController < ApplicationController
  before_action :get_user, only: [:balance, :history]

  def login
    begin
      user = User.find_by(email: params[:email])
      if user.nil?
        render json: {
          :is_success => false,
          :message => "User not found"
        } and return
      end

      if user&.authenticate(params[:password])
        session = Session.create(user: user)
        render json: {:is_success => true, :name => user.name, token: session.token}
      else
        render json: {
          :is_success => false,
          :message => "Invalid password"
        }
      end
    rescue => e
      render json: {:is_success => false,error: e.message}, status: 500
    end
  end

  def logout
    session_id = request.headers['Cookie'].split('=').last
    session = Session.find_by(token: session_id)

    if session.destroy
      render json: {:is_success => true, :message => "Logged out"}
    else
      render json: {is_success: false, message: "Failed to delete session."}, status: 500
    end
  end

  def balance
    render json: {
      :is_success => true,
      :account_name => @user.name,
      :role => @user.role,
      :balance => @user.wallet.balance
    }
  end

  def history
    trx = Transaction
            .where(source_wallet_id: @user.id).or(Transaction.where(target_wallet_id: @user.id)).order(id: :desc)
    render json: {:is_success => true, :history => trx}
  end

  private

  def get_user
    cookie = request.headers['Cookie']
    if cookie.nil? || cookie.empty?
      render json: {is_success: false, message: 'Invalid session id'}, status: 500 and return
    end
    token = Session.find_by(token: cookie.split('=').last)
    if token.nil?
      render json: {is_success: false, message: 'Invalid session id'}, status: 500 and return
    else
      if token.created_at + 24.hours <= Time.current
        render json: {is_success: false, message: 'Invalid session expired'}, status: 500 and return
      end
      @user = token.user
    end
  end
end
