# Welcome2 Command Line Interface

This is a command line interface to the solo version of Welcome 2, although it's meant to be a first draft of a more extensible interface to a board game state navigator.

## Installation

Git clone this repo, as well as the repos `welcome2_game`, and `welcome2_constants` into the same root folder structure.

```
$ git clone https://github.com/philihp/welcome2_cli.git
$ git clone https://github.com/philihp/welcome2_game.git
$ git clone https://github.com/philihp/welcome2_constants.git
```

Then from each of those repositories, get their dependencies

```
$ mix deps.get
```

Update the file `lib/welcome2_cli/interact.ex`, and change the constant's hostname. You'll want this to be your machine name. If you're not sure what this would be, start a server as in the next step

```elixir
@server :"welcome2_game@valencia.local"
```

## Server Startup

From the `welcome2_game` folder, startup a server with

```
$ iex --name welcome2_game -S mix
```

You should see a prompt that looks like

```
iex(welcome2_game@HOSTNAME)1>
```

HOSTNAME should match the name of what you set the server to in the last step of installation.

## Client Startup

In another terminal window, navigate to the `welcome2_cli` folder, and startup the CLI with

```
$ elixir --name welcome2_cli -S mix run -e Welcome2Cli.start
```

A new game should be started. You can start up multiple game session terminal clients like this.
