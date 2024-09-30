class Wallet < ApplicationRecord
  belongs_to :entity, polymorphic: true
  has_many :outgoing_transactions, class_name: 'Transaction', foreign_key: :source_wallet_id, dependent: :nullify
  has_many :incoming_transactions, class_name: 'Transaction', foreign_key: :target_wallet_id, dependent: :nullify

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def credit(amount)
    update!(balance: balance + amount)
  end

  def debit(amount)
    raise "Insufficient funds" if balance < amount
    update!(balance: balance - amount)
  end
end
