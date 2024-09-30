class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.references :entity, polymorphic: true, index: true
      t.decimal :balance, precision: 10, scale: 2, default: 0.0, null: false

      t.timestamps
    end
  end
end
