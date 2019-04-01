# phoenix_graphql_playground

This is a small playground to see the possibilities to make a GraphQL API with elixir based on phoenix and absinthe.  
This an "umbrella application", with a frontal phoenix application deserving the graphql schema and queries / mutations.  
The resolvers are in others applications.  
I tried to apply the "micro service" architecture design with an umbrella application.  

Each queries / mutations will fall into a domain (see domain driven design), each domain will be translated into one or few micro services ( and here as applications on the umbrella).

In this playground, all the applications have a specific role :

- front : the phoenix app with absinthe, exposing the graphql API over HTTP
- person : application to manage people(users), like sign in and sign out resolvers
- db_connector: application that exposes the data model, with ecto(ORM)
- notification: application to send notifications like emails and sms, with mailjet API

The actual project implement a regular sign in, sign up and sign out process.
It handles authentication with JWT, using hex module "Guardian".
There is only one query protected with JWT authentication for the moment, the "findByEmail" query

## Getting started

First you must rename config/docker.dist.env to config/docker.env and set environment variables, like mailjet api key keys

Then use the makefile to run the the project.
Use "make help" to list the available options.
You can run the project localy with elixir installed or with docker and docker-compose.




### to create the database with docker and initiliase it
first, run db with "make start_db" and then run "make reset_db".
It will start the db, drop the database and recreate it, and insert some seed data. 