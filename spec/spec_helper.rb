require 'rspec'
require 'ffi/hackrf/version'

include FFI::HackRF

RSpec.configure do |rspec|
  rspec.before(:suite) do
    ptr = FFI::MemoryPointer.new(:pointer)

    FFI::HackRF.hackrf_open(ptr)

    @device = FFI::HackRF::Device.new(ptr.read_pointer)
  end

  rspec.after(:suite) do
    FFI::HackRF.hackrf_close(@device)
  end
end
