# ApiUmbrella

This is a small playground to see the possibilities to make a GraphQL API with elixir based on phoenix and absinthe.
This an "umbrella application", with a frontal phoenix application deserving the graphql schema and queries / mutations.
The resolvers are in others applications.
I tried to apply the "micro service" architecture design with an umbrella application.

Each queries / mutations will fall into a domain (see domain driven design), each domain will be translated into one or few micro services ( and here as applications on the umbrella).

In this playground, all the applications have a specific role :

- front : the phoenix app with absinthe, exposing the graphql API over HTTP
- person : application to manage people(users), like sign in and sign out resolvers
- db_connector: application that exposes the data model, with ecto(ORM)
- notification: application to send notifications like emails and sms, with mailjet

The actual project implement a regular sign in, sign up and sign out process.
It handles authentication with JWT, using hex module "Guardian".
There is only one query protected with JWT authentication for the moment, the "findByEmail" query

## Getting started

First you must rename config/docker.dist.env to config/docker.env and set environment variables, like mailjet api key keys


**TODO: Add description**

# api_umbrella


### to create db run 
first, run db with "make start_db" and then run  "mix ecto.create"