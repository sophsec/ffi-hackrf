require 'ffi'

module FFI
  module HackRF
    class Transfer < FFI::Struct

      layout :device, :pointer,
             :buffer, :pointer,
             :buffer_length, :int,
             :valid_length,  :int,
             :rx_ctx,        :pointer,
             :tx_ctx,        :pointer

      def length
        self[:valid_length]
      end

      def buffer
        self[:buffer].read_bytes(length)
      end

      def buffer=(data)
        if data.size > self[:buffer_length]
          raise(ArgumentError,"data cannot fit within the buffer")
        end

        self[:buffer].write_bytes(data)
        self[:valid_length] = data.size

        return data
      end

    end
  end
end
