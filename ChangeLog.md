# Revision history for staversion

## 0.2.1.2  -- 2017-07-29

* Fix build and test with `megaparsec-4`.


## 0.2.1.1  -- 2017-07-29

* Support `megaparsec-6.0`, with compatibility wrapper "Staversion.Internal.Megaparsec".
* Support `Cabal-2.0`, with compatibility wrapper "Staversion.Internal.Version".


## 0.2.1.0  -- 2017-06-18

* Add `--format-version` option.
* `--format-version cabal-caret` option uses the caret operator (`^>=`) if possible. (#2)


## 0.2.0.0  -- 2017-05-14

* [breaking change] `pvp` aggregator now does "trailing-zero
  normalization". For example, it now assumes versions "2.2" and
  "2.2.0.0" are practically the same (#2).
* Add `pvp-major` aggregator, which is just an alias for `pvp`
  aggregator.
* Add `pvp-minor` aggregator, which is similar to `pvp-major` but it
  uses minor versions for upper bounds (#2).


## 0.1.4.0  -- 2017-04-08

* Add `--aggregate` option, which aggregates versions in different LTS resolvers.
  There are `or` and `pvp` aggregators.
* Bug fix: when it fails to load a given .cabal file, now it continues processing the next target.


## 0.1.3.2  -- 2017-01-05

* Fix dependency lower bound for `base`.
  It was `>=4.6`, but now it's `>=4.8` due to dependency on `megaparsec`.

## 0.1.3.1  -- 2017-01-03

* Now staversion can parse the "curly brace" format of .cabal files (to some extent.)
* Confirmed test with `aeson-1.1.0.0`.

## 0.1.3.0  -- 2016-12-29

* Now staversion shows the exact resolver for a partial resolver (e.g. "lts-4" -> "lts-4.2")
* Now staversion reads .cabal files, and uses their `build-depends` fields as query.
* Fix minor error in ordering the result.

## 0.1.2.0  -- 2016-11-10

* New option `--hackage`, which searches hackage for the latest version number.

## 0.1.1.0  -- 2016-11-03

* Now staversion fetches build plan YAML files over network, if necessary.
* Now staversion disambiguates partial resolvers (e.g. "lts-2") into exact resolvers (e.g. "lts-2.22").
* New option `--no-network`, which forbids staversion to access network.

## 0.1.0.0  -- 2016-10-16

* First version. Released on an unsuspecting world.
