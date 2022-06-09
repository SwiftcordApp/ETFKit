# ETFKit

[![Build and test](https://github.com/SwiftcordApp/ETFKit/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/SwiftcordApp/ETFKit/actions/workflows/build-and-test.yml)

Encoder/decoder for Erlang's [External Term Format](https://www.erlang.org/doc/apps/erts/erl_ext_dist.html) (version 131). 

Designed to be a drop-in replacement for JSONDecoder/JSONEncoder. Simply
replace all usages of JSONDecoder/JSONEncoder with ETFEncoder/ETFDecoder. (WIP)

### Types that can be encoded/decoded:

- [x] `nil`
- [x] `Bool`
- [x] `String`
- [ ] Atoms
- [x] `String` with unicode
- [x] `Double`
- [x] `Int8`
- [x] `Int32`
- [ ] `Int64`
- [x] Objects
- [x] Arrays with any supported type
- [ ] Tuples
- [ ] PIDs
- [ ] Ports
- [ ] Exports
- [ ] References
