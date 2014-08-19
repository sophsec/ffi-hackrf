require 'ffi/hackrf/register_array'

module FFI
  module HackRF
    class RFFC5071 < RegisterArray

      private

      def read(register,value)
        HackRF.hackrf_rffc5071_read(@device,register,value)
      end

      def write(register,value)
        HackRF.hackrf_rffc5071_write(@device,register,value)
      end

    end
  end
end
