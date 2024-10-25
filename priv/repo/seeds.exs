# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RentACar.Repo.insert!(%RentACar.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

alias RentACar.Repo
alias RentACar.Rentals.{Car, Booking, Review}
alias RentACar.Accounts.User

# Users

nate =
  %User{}
  |> User.changeset(%{
    username: "nate_dawg",
    first_name: "Nathan",
    last_name: "Sinna",
    email: "nate@test.com",
    password: "12345678a!"
  })
  |> Repo.insert!()

ezra =
  %User{}
  |> User.changeset(%{
    username: "king_ezra",
    first_name: "Ezra",
    last_name: "Sinna",
    email: "ezra@test.com",
    password: "12345678a!"
  })
  |> Repo.insert!()

caleb =
  %User{}
  |> User.changeset(%{
    username: "prince_caleb",
    first_name: "Caleb",
    last_name: "Sinna",
    email: "caleb@test.com",
    password: "12345678a!"
  })
  |> Repo.insert!()

# Cars

# images_url = "#{RentACarWeb.Endpoint.url()}/images"

%Car{
  name: "Toyota Sienna",
  slug: "toyota-sienna",
  description: "Perfect Family Hauler",
  price_per_day: Decimal.from_float(250.00),
  image: "toyota_sienna.jpg",
  image_thumbnail: "toyota_sienna_thumbnail.jpg",
  passengers: 8,
  navigation: true,
  electric: false,
  bookings: [
    %Booking{
      start_date: ~D[2024-11-18],
      end_date: ~D[2024-11-21],
      total_price: Decimal.from_float(750.00),
      user: nate
    }
  ]
}
|> Repo.insert!()

%Car{
  name: "Tesla Cybertruck",
  slug: "tesla-cybertruck",
  description: "Bullet-proof for extra protection!",
  price_per_day: Decimal.from_float(1000.00),
  image: "cybertruck.jpg",
  image_thumbnail: "cybertruck_thumbnail.jpg",
  passengers: 6,
  navigation: true,
  electric: true,
  bookings: [
    %Booking{
      start_date: ~D[2024-10-29],
      end_date: ~D[2024-10-31],
      total_price: Decimal.from_float(2000.00),
      user: ezra
    }
  ],
  reviews: [
    %Review{
      comment: "Whoa, it's fast!!!",
      rating: 5,
      user: ezra,
      inserted_at: DateTime.from_naive!(~N[2024-10-30 19:00:00], "Etc/UTC")
    }
  ]
}
|> Repo.insert!()

%Car{
  name: "Porsche Panamera",
  slug: "porsche-panamera",
  description: "Luxury sports sedan",
  price_per_day: Decimal.from_float(700.00),
  image: "porsche_panamera.jpg",
  image_thumbnail: "porsche_panamera_thumbnail.jpg",
  passengers: 4,
  navigation: true,
  electric: false,
  bookings: [
    %Booking{
      start_date: ~D[2024-06-10],
      end_date: ~D[2024-06-17],
      total_price: Decimal.from_float(4900.00),
      user: ezra
    },
    %Booking{
      start_date: ~D[2024-11-07],
      end_date: ~D[2024-11-12],
      total_price: Decimal.from_float(3500.00),
      user: nate
    }
  ],
  reviews: [
    %Review{
      comment: "Luxurious and fast",
      rating: 5,
      user: nate,
      inserted_at: DateTime.from_naive!(~N[2024-11-15 19:00:00], "Etc/UTC")
    },
    %Review{
      comment: "Wish it was electric!",
      rating: 4,
      user: caleb,
      inserted_at: DateTime.from_naive!(~N[2024-05-19 19:00:00], "Etc/UTC")
    },
    %Review{
      comment: "Fit all my golf clubs",
      rating: 5,
      user: ezra
    }
  ]
}
|> Repo.insert!()
