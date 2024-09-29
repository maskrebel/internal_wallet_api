class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, inclusion: { in: %w[credit debit transfer] }

  after_create :process_transaction

  private

  def process_transaction
    ActiveRecord::Base.transaction do
      if transaction_type == "transfer"
        source_wallet.debit(amount)
        target_wallet.credit(amount)
      elsif transaction_type == "credit"
        source_wallet.credit(amount)
      elsif transaction_type == "debit"
        source_wallet.debit(amount)
      end
    end
  end
end
