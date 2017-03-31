class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :article, foreign_key: true
      t.text :comment

      t.timestamps
    end
  end
end