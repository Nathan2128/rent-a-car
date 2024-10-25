defmodule RentACar.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :rating, :integer, null: false
      add :comment, :string, null: false
      add :car_id, references(:cars), null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create index(:reviews, [:car_id])
    create index(:reviews, [:user_id])
  end
end
