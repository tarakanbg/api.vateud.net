class AddCsvFileToMassBookings < ActiveRecord::Migration
  def self.up
    add_attachment :mass_bookings, :csv_file
  end

  def self.down
    remove_attachment :mass_bookings, :csv_file
  end
end
