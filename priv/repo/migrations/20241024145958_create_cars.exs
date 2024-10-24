defmodule RentACar.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :description, :string, null: false
      add :price_per_day, :decimal, null: false
      add :image, :string, null: false
      add :image_thumbnail, :string, null: false
      add :passengers, :integer, null: false
      add :navigation, :boolean, default: false, null: false
      add :electric, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:cars, [:slug])
    create unique_index(:cars, [:name])
  end
end
