alias DbConnector.Repo
alias DbConnector.{Person,Permission}

# Create 5 seed users
customerPermissions= %{
  queries: [:people],
  mutations: [:create_person]
}
## insert 3 customers
for _ <- 1..3 do
  Repo.insert!(%Person{
    first_name: Faker.Name.first_name,
    last_name: Faker.Name.last_name,
    email: Faker.Internet.safe_email(),
    email_token: UUID.uuid4(),
    role: 2,
    inserted_at: DateTime.utc_now,
    updated_at: DateTime.utc_now,
    password_hash: Bcrypt.hash_pwd_salt("customer")
  })
end

## insert 2 admins
for _ <- 1..2 do
  Repo.insert!(%Person{
    first_name: Faker.Name.first_name,
    last_name: Faker.Name.last_name,
    email: Faker.Internet.safe_email(),
    email_token: UUID.uuid4(),
    role: 1,
    inserted_at: DateTime.utc_now,
    updated_at: DateTime.utc_now,
    password_hash: Bcrypt.hash_pwd_salt("administrator")
  })
end
## insert 2 anonymous
for _ <- 1..2 do
  Repo.insert!(%Person{
    first_name: Faker.Name.first_name,
    last_name: Faker.Name.last_name,
    email: Faker.Internet.safe_email(),
    email_token: UUID.uuid4(),
    role: 0,
    inserted_at: DateTime.utc_now,
    updated_at: DateTime.utc_now,
    password_hash: Bcrypt.hash_pwd_salt("anonymous")
  })
end

Repo.insert!(%Permission{
  operation_type: 0,
  role: 2,
  value: "people"
})