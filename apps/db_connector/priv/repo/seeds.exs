alias DbConnector.Repo
alias DbConnector.Person

# Create 5 seed users

for _ <- 1..5 do
  Repo.insert!(%Person{
    first_name: Faker.Name.first_name,
    last_name: Faker.Name.last_name,
    email: Faker.Internet.safe_email(),
    email_token: UUID.uuid4(),
    inserted_at: DateTime.utc_now,
    updated_at: DateTime.utc_now,
    password_hash: Bcrypt.hash_pwd_salt("password")
  })
end