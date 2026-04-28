class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :user,       null: false, foreign_key: true
      t.date       :date,       null: false
      t.time       :start_time, null: false
      t.time       :end_time,   null: false
      t.string     :notes
      t.integer    :status,     null: false, default: 0

      t.timestamps
    end

    add_index :bookings, [:date, :start_time]
  end
end
