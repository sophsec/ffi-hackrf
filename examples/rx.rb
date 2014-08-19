#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../../lib',__FILE__))

require 'ffi/hackrf'

FFI::HackRF.open do |hackrf|
  hackrf.frequency   = 90.1 * (10 ** 6)
  hackrf.sample_rate = 44.8 * (10 ** 3)

  hackrf.rx do |transfer|
    puts transfer.buffer.dump
  end
end
