class CreateActions < ActiveRecord::Migration[8.0]
  def change
    create_table :actions do |t|
      t.timestamps
      t.string :action_type, null: false
      t.integer :block_transaction_id, null: false

      # Store the action data as json since the data attribute is not uniform across actions types.
      # This is in anticipation for future features such as displaying Transactions of other types 
      # such as FunctionCall.
      t.json :data, null: false
    end

    # Each Action must be associated with the BlockTransaction it was derived from.
    add_foreign_key :actions, :block_transactions
  end
end
