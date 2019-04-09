Welcome to my first article on Medium!

## Introduction

I would like to share with you the last language and framework i discovered recently: Elixir and Phoenix framework.
You should ask what is Elixir ?

Elixir is a "dynamic, functional language designed for building scalable and maintainable applications. " from the official website.
It was first released in 2011, and is build on top of an older language: [Erlang](https://www.erlang.org/) and shares the same abstractions for building distributed, fault-tolerant applications.
The language is compiled to bytecode and the is exectued on the Erlange virtual machine called BEAM, it support meta programming with macros and polymorphism via protocols.

A distributed application in Elixir/Erlang is called an OTP application.


I ths playground, i will try to demonstrate the main features of the language and thoses frameworks through the creation of a small web api, exposing a [GraphQL](https://graphql.org/) endpoint.

To build this application, we will use two frameworks/libraries of the elixir world : Phoenix and Absinthe.  
Phoenix is the main framework in Elixir stack to create a web serveur.
It's a MVC framework largely inspired by Ruby on Rails wich is famous framework for the web wich  provides a structure that allows  to develop quickly and intuitively.
Then comes [Absinthe](https://absinthe-graphql.org/), wich is the main implementation of the GraphQL spec in the elixir world.
Absinthe is fully compatible with Phoenix.

## Installation

To start, let's intall Elixir on your machine.

### On Mac OS X with Homebrew:   

"brew update" to update you homebrew then "brew install elixir" 

With Macports : "sudo port install elixir"  

### On windows:

[Download the installer](https://repo.hex.pm/elixir-websetup.exe)
Run the "elixir-websetup.exe"

### On Ubuntu:

- Add Erlang Solutions repo: "wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb"
- Run: sudo apt-get update
- Run: sudo apt-get install esl-erlang
- Install Elixir: sudo apt-get install elixir

## Setup the project

The higher level of abstraction in Elixir is called an Application, it's the standard way to package software in Erlang/OTP.
Its a bit like the concept of library in other languages with additionals characteristics.
An application can be one of the two types:
- a library
- a running application (for example a web server with Phoenix)

An application in elixir has a lifecycle, it must be start and then shutdown.

Elixir allow us to create a special type of application called "umbrella application".
It's a regular application containing smallers applications.
You can compare it to micro service architecture with limitations.
In the playground we will create an umbrella application with four applications :
- db_connector wich will contain the ORM/Data models of the system
- front, which will run the phoenix HTTP application with Absinthe desserving the GraphQL schema
- person, will manage regular "users", handle sign in/sign up proccess and role base access management with JWT tokens.

To start with this, we will use the great tools packaged with elixir, called "Mix".
The goal of this tool is to manage a lot of thing for us like :
- build/compile code
- run the application after build/compile
- run tasks, called "mix tasks"
- manage dependencies (with a dedicated mix task)
- create library/applications skeletons
- run test
- format code
- remote debugging
- ...

The first thing to do is to install the package manager of Erlang/elixir, run "mix local.hex".
Then we need to install the phoenix Mix archive, that will allow us to use the phoenix mix tasks.
to do this, run " mix archive.install hex phx_new 1.4.3 "
Ok we are now ready to generate the applications with mix.
Firt lets create the umbrella application itself : mix new phoenix_graphql_playground --umbrella

this will generate the skeleton of the umbrella application, with a folder called "apps". 
this folder will contains our four applications. 
After this, move in the apps folder and generate the first application with the phoenix task :
cd ./phoenix_graphql_playground/apps
mix phx.new front --no-ecto --no-webpack --no-html

The option --no-ecto tells phoenix to not configure ecto (the ORM), and --no-webpack is usefull when you don't want to generates the assets with wepack. We are buildling a API with no rendering at all,so it's a good choice.  

then generate the others applications :
mix new db_connector --sup
mix new person --sup

move to the config folder at the root of the project, and create a docker.env file.
We will set our environments variables inside it.

copy this content inside
HOSTNAME=localhost
SECRET_KEY_BASE="u1QXlca4XEZKb1o3HL/aUlznI1qstCNAQ6yme/lFbFIs0Iqiq/annZ+Ty8JyUCDc"
DATABASE_HOST=api_umbrella
DATABASE_USER=postgres
DATABASE_PASS=postgres
DATABASE_NAME=api_umbrella
PORT=4000
LANG=en_US.UTF-8
REPLACE_OS_VARS=true
ERLANG_COOKIE=myapp
DOCKER_REGISTRY=
DOCKER_USERNAME=
DOCKER_PASSWORD=

Then set the values you want.
Then download the docker files and the Makefile :

wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/fosk06/phoenix_graphql_playground/master/docker-compose.yml
wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/fosk06/phoenix_graphql_playground/master/Dockerfile
wget --no-check-certificate --content-disposition https://raw.githubusercontent.com/fosk06/phoenix_graphql_playground/master/Makefile