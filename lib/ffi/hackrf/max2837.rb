require 'ffi/hackrf/register_array'

module FFI
  module HackRF
    class MAX2837 < RegisterArray

      private

      def read(register,value)
        HackRF.hackrf_max2837_read(@device,register,value)
      end

      def write(register,value)
        HackRF.hackrf_max2837_write(@device,register,value)
      end

    end
  end
end
