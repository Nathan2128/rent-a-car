defmodule RentACar.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :start_date, :date, null: false
      add :end_date, :date, null: false
      add :state, :string, null: false
      add :total_price, :decimal
      add :car_id, references(:cars), null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create index(:bookings, [:car_id, :user_id])
  end
end
