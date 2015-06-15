class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|

      t.references :post
      t.references :user
      t.references :comment

      t.timestamps
    end
  end
end
