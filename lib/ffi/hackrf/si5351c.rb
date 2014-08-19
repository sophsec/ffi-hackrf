require 'ffi/hackrf/register_array'

module FFI
  module HackRF
    class Si5351C < RegisterArray

      private

      def read(register,value)
        HackRF.hackrf_si5351c_read(@device,register,value)
      end

      def write(register,value)
        HackRF.hackrf_si5351c_write(@device,register,value)
      end

    end
  end
end
