module FFI
  module HackRF
    class SPIFlash

      def initialize(device)
        @device = device
      end

      def erase!
        HackRF.hackrf_spiflash_erase(@device)
      end

      def write(address,data)
        HackRF.hackrf_spiflash_write(@device,address,data.bytes.length,data)
      end

      def read(address,length)
        buffer = FFI::Buffer.new(:uchar,length)

        HackRF.hackrf_spiflash_read(@device,address,buffer,length)

        return buffer.read_bytes(length)
      end

    end
  end
end
