class RemoveDepositFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :deposit, :boolean
  end
end
