require 'ffi'

module FFI
  module HackRF
    class RegisterArray

      #
      # Initializes the register array.
      #
      def initialize(device)
        @device = device
      end

      #
      # @param [Fixnum] register
      #
      # @return [Fixnum]
      #
      def [](register)
        value = FFI::MemoryPointer.new(:uint16)

        read(register,value)

        return value.read_uint16
      end

      #
      # @param [Fixnum] register
      #
      # @param [Fixnum] value
      #
      def []=(register,value)
        write(register,value)
      end

      private

      #
      # @param [Integer] register
      #
      # @param [FFI::MemoryPointer] value
      #
      # @abstract
      #
      def read(register,value)
      end

      #
      # @param [Fixnum] register
      #
      # @param [Fixnum] value
      #
      # @abstract
      #
      def write(register,value)
      end

    end
  end
end
