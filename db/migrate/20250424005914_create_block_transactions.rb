class CreateBlockTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :block_transactions do |t|
      t.timestamps

      # Required data points modeled from the API Transaction object
      #   - trans_hash is used to ensure we do not duplicate transactions in the table
      #   - sender and reciever are both requierd data points for the index
      t.string :trans_hash, null: false, index: {unique: true}
      t.string :sender, null: false
      t.string :receiver, null: false

      # The assumption is that we want to display only successful transactions in the list
      t.boolean :success, null: false

      # Not explicitly required but storing in anticipation for future features. If storage
      # space is of concern these columns can be removed.
      t.string :gas_burnt
      t.string :block_hash
      t.integer :height
      t.string :trans_time
      t.integer :trans_id

      # Aggregate data columns to remove the need for querying Actions table
      #   - contains_transfer is set to true if the Transaction has an associated Action of type Transfer
      #   - transfer_desposit will store the deposit value of the last associated Action of type Transfer if
      #     contains_transfer is true. Stored as a string since SQLite Integer cannot store values larger than 8 bytes.
      t.boolean :contains_transfer, null: false
      t.string :transfer_deposit
    end
  end
end
