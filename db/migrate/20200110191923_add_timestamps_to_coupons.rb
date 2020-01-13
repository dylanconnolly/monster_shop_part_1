class AddTimestampsToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_timestamps(:coupons)
  end
end
