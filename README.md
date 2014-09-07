# ffi-hackrf

* [Homepage](https://github.com/sophsec/ffi-hackrf#readme)
* [Issues](https://github.com/sophsec/ffi-hackrf/issues)
* [Documentation](http://rubydoc.info/gems/ffi-hackrf/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

(Experimental) FFI bindings for [libhackrf].

## Examples

    require 'ffi/hackrf'

## Requirements

* [libhackrf]
* [ffi] ~> 1.0

## Install

    $ gem install ffi-hackrf

## Examples

```ruby
require 'ffi/hackrf'

FFI::HackRF.open do |hackrf|
  hackrf.frequency   = 90.1 * (10 ** 6)
  hackrf.sample_rate = 44.8 * (10 ** 3)

  hackrf.rx do |transfer|
    puts transfer.buffer.dump
  end
end
```

## Copyright

Copyright (c) 2014 Postmodern

See {file:LICENSE.txt} for details.

[libhackrf]: https://github.com/mossmann/hackrf/tree/master/host/libhackrf
