require 'ffi/hackrf/ffi'
require 'ffi/hackrf/device'
require 'ffi/hackrf/part_id_serial_number'
require 'ffi/hackrf/version'

module FFI
  module HackRF
    #
    # @yield [hackrf]
    #
    # @yieldparam [Device] hackrf
    #
    # @return [Device]
    #
    def self.open(&block)
      Device.open(&block)
    end
  end
end

FFI::HackRF.hackrf_init

at_exit { FFI::HackRF.hackrf_exit }
