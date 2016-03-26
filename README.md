AgentDemo [![Build Status](https://travis-ci.org/mkrogemann/agent_demo.svg)](https://travis-ci.org/mkrogemann/agent_demo)
============

An implementation of Tic Tac Toe to serve as a demo of Elixir's Agent abstraction.

Accompanies this blog post: TODO_LINK

# Build

After cloning the repo and cd'ing into the appropriate directory, do this:

``` bash
mix deps.get
mix test
mix escript.build
```

You don't have to run the tests of course, I added that line just in case you want to verify the app.

The target ```escript.build``` produces an executable escript. An [escript](http://erlang.org/doc/man/escript.html) can be run on any machine that has Erlang installed.

# Play

The implementation is based on what is specified in the Tic Tac Toe Application Kata that you can find [here](http://ccd-school.de/coding-dojo/).

It diverges from the aforementioned Kata in some respects.

The display and expected input is not zero-based as I think that humans can relate better to one-based notation and the app expects its input in English, i.e. "new" and "end" for a new game and for quitting the application.

What you need to do after a (hopefully successful) build is this:

``` bash
./tictactoe
```

Enjoy playing and learning about Elixir.

And as always: Constructive feedback is most welcome :)
