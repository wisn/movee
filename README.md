# Movee
An OMDb API consumer. Programming Club exercise at Telkom University.

## Requirements
- `ghc` version 8.0.1
- `aeson` package
- `http-conduit` package

## Demo
### Usage
```command
runhaskell movee NAME [YEAR]
```

### Example
```command
runhaskell movee who am i
```
```
Title  : Who Am I
Year   : 2014
Genre  : Crime, Drama, Sci-Fi
Rating : 7.6

Benjamin, a young German computer whiz, is invited to join a subversive hacker group that wants to be noticed on the world's stage.

This movie is awesome! Looks like worth for us!
```

With year:
```
runhaskell movee one day 2016
```
```
Title  : One Day
Year   : 2016
Genre  : Romance
Rating : 8.4

N/A

This movie is awesome! Looks like worth for us!
```

Another example:
```command
runhaskell movee zombeavers
```
```
Title  : Zombeavers
Year   : 2014
Genre  : Comedy, Horror, Thriller
Rating : 4.8

A fun weekend turns into madness and horror for a bunch of groupies looking for fun in a beaver infested swamp.

Well, this movie quite modern but has bad rating...
```
