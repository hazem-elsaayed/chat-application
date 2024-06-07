class AddConstraintsToTokenInApplications < ActiveRecord::Migration[7.1]
  def change
    change_column_null :applications, :token, false
    add_index :applications, :token, unique: true
  end
end