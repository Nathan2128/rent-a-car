# RentACar GraphQL API

To set up environment to test out the RentACar GraphQL API: 

1. Create the database: `mix ecto.create`
2. Migrate tables to the databse: `mix ecto.migrate`
3. Seed the Database: `mix run priv/repo/seeds.exs`

Run the application: `mix phx.server`
Now you can visit [`localhost:4001`](http://localhost:4001/graphiql) from your browser.

Example Queries: 

# Fetch a Car by Slug
```
query {
  car(slug: "tesla-model-s") {
    id
    name
    description
    pricePerDay
    electric
    passengers
  }
}
```

# List Cars with Filters
```
query {
  cars(
    limit: 10
    order: asc
    filter: {
      matching: "Tesla"
      electric: true
      passengers: 5
      availableBetween: { startDate: "2023-12-01", endDate: "2023-12-10" }
    }
  ) {
    id
    name
    description
    pricePerDay
    electric
    passengers
  }
}
```

# Create a Booking (Authenticated)
```
mutation {
  createBooking(carId: 1, startDate: "2023-12-01", endDate: "2023-12-10") {
    id
    startDate
    endDate
    totalPrice
    car {
      name
    }
  }
}
```

# Cancel a Booking (Authenticated)
```
mutation {
  cancelBooking(bookingId: 1) {
    id
    state
  }
}
```

# Create a Review (Authenticated)
```
mutation {
  createReview(carId: 1, rating: 5, comment: "Great experience!") {
    id
    rating
    comment
    car {
      name
    }
  }
}
```

# Sign up
```
mutation {
  signUp(
    username: "johndoe"
    email: "johndoe@example.com"
    password: "securePassword123"
    firstName: "John"
    lastName: "Doe"
  ) {
    token
    user {
      id
      username
    }
  }
}
```

# Sign in
```
mutation {
  signIn(username: "johndoe", password: "securePassword123") {
    token
    user {
      id
      username
    }
  }
}
```


