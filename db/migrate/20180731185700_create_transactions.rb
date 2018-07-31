class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.date :posted_on, null: false, default: { expr: "('now'::text)::date" }, index: true
      t.string :payee, null: false, index: true
      t.string :description, null: false, default: ""
      t.string :category, null: false, index: true
      t.decimal :amount, precision: 8, scale: 2, null: false
      t.boolean :deposit, null: false, default: false, index: true

      t.timestamps
    end
  end
end
