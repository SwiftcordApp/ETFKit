# ETFKit

[![Build and test](https://github.com/SwiftcordApp/ETFKit/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/SwiftcordApp/ETFKit/actions/workflows/build-and-test.yml)

Decode/encode Erlang External Term format (ETF) version 131. 

Designed to be a drop-in replacement for JSONDecoder/JSONEncoder. Simply
replace all usages of JSONDecoder/JSONEncoder with ETFEncoder/ETFDecoder. (WIP)

### Things that can be packed:

- [x] `nil`
- [x] `Bool`
- [x] `String`
- [ ] Atoms
- [x] Unicode Strings
- [x] `Double`
- [x] `Int8`
- [x] `Int32`
- [ ] `Int64`
- [x] Objects
- [x] Arrays
- [ ] Tuples
- [ ] PIDs
- [ ] Ports
- [ ] Exports
- [ ] References
