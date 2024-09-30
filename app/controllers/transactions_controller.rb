class TransactionsController < ApplicationController
  before_action :set_wallets, only: [:create]

  def create
    transaction_type = params[:transaction_type]

    if %w[debit credit transfer].include? transaction_type
      handle_transaction
    else
      render json: { message: 'Invalid transaction type' }, status: not_found
    end
  end

  private

  def set_wallets
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
      user = token.user
    end

    @source_wallet = user.wallet
    @target_wallet = Wallet.find_by(entity_id: params[:target_wallet_id])
  end

  def handle_transaction
    if params[:transaction_type] == 'transfer' and @target_wallet.nil?
      raise ActiveRecord::Rollback, 'Target wallet not found'
    elsif %w[debit credit].include? params[:transaction_type] and @source_wallet.nil?
      raise ActiveRecord::Rollback, 'Source wallet not found'
    end

    @transaction = Transaction.new(
      transaction_type: params[:transaction_type],
      target_wallet: @target_wallet,
      source_wallet: @source_wallet,
      amount: params[:amount],
      description: params[:description]
    )

    if @transaction.save
      render json: @transaction, status: :created
    else
      raise ActiveRecord::Rollback, @transaction.errors.full_messages.to_sentence
    end
  end
end
