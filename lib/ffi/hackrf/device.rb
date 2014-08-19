require 'ffi/hackrf/spiflash'
require 'ffi/hackrf/max2837'
require 'ffi/hackrf/si5351c'
require 'ffi/hackrf/rffc5071'
require 'ffi/hackrf/ffi'

require 'ffi'

module FFI
  module HackRF
    #
    # Represents the opaque `hackrf_device` type.
    #
    class Device

      #
      # @return [SPIFlash]
      #
      attr_reader :spiflash

      #
      # @return [MAX2837]
      #
      attr_reader :max2837

      #
      # @return [Si5351C]
      #
      attr_reader :si5351c

      #
      # @return [RFFC5071]
      #
      attr_reader :rffc5071

      #
      # Initializes the device.
      #
      # @param [FFI::Pointer] ptr
      #
      def initialize(ptr)
        @ptr  = ptr
        @mode = nil

        @spiflash = SPIFlash.new(self)
        @max2837  = MAX2837.new(self)
        @si5351c  = Si5351C.new(self)
        @rffc5071 = RFFC5071.new(self)
      end

      def self.open
        ptr = FFI::MemoryPointer.new(:pointer)

        HackRF.hackrf_open(ptr)

        device = new(ptr.read_pointer)

        if block_given?
          yield device
          device.close
        else
          return device
        end
      end

      def self.finalize(device)
        HackRF
      end

      def board_id
        ptr = FFI::MemoryPointer.new(:uint8)

        HackRF.hackrf_board_id_read(self,ptr)

        return ptr.read_uint8
      end

      def version_string
        buffer = FFI::Buffer.new(255)

        HackRF.hackrf_version_string_read(self,buffer,buffer.size)

        return buffer.get_string(0)
      end

      def part_id_and_serial_number
        part_id_serial_number = PartIDSerialNumber.new

        HackRF.hackrf_board_partid_serialno_read(self,part_id_serial_number)

        return part_id_serial_number
      end

      #
      # @param [Integer] bandwidth
      #   The bandwidth in Hz.
      #
      def baseband_filter_bandwidth=(bandwidth)
        HackRF.hackrf_set_baseband_filter_bandwidth(self,bandwidth)
      end

      def frequency=(freq)
        HackRF.hackrf_set_freq(self,freq)
      end

      alias freq= frequency=

      def sample_rate=(rate)
        HackRF.hackrf_set_sample_rate(self,rate)
      end

      def amp=(value)
        HackRF.hackrf_set_amp_enable(self,value)
      end

      def lna_gain=(gain)
        HackRF.hackrf_set_lna_gain(self,gain)
      end

      def vga_gain=(gain)
        HackRF.hackrf_set_vga_gain(self,gain)
      end

      def txvga_gain=(gain)
        HackRF.hackrf_set_txvga_gain(self,gain)
      end

      def antenna=(value)
        HackRF.hackrf_set_antenna_enable(self,value)
      end

      def streaming?
        HackRF.hackrf_is_streaming(self) == :true
      end

      def rx(&block)
        @mode = :rx
        @rx_callback = callback(&block)

        HackRF.hackrf_start_rx(self,@rx_callback,nil)

        @rx_callback = nil
        @mode = nil
      end

      def tx(&block)
        @mode = :tx
        @tx_callback = callback(&block)

        HackRF.hackrf_start_tx(self,@tx_callback,nil)

        @tx_callback = nil
        @mode = nil
      end

      def stop
        case @mode
        when :rx then HackRF.hackrf_stop_rx(self)
        when :tx then HackRF.hackrf_stop_tx(self)
        end
      end

      def closed?
        @ptr.nil?
      end

      def close
        ret = HackRF.hackrf_close(self)
        @ptr = nil

        return ret
      end

      def to_ptr
        @ptr
      end

      private

      def callback(&block)
        lambda { |transfer| block.call(Transfer.new(transfer)) }
      end

    end
  end
end
