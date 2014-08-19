require 'ffi'

module FFI
  module HackRF
    class PartIDSerialNumber < FFI::Struct

      layout :part_id,   [:uint32, 2],
             :serial_no, [:uint32, 4]

      def part_id
        (self[:part_id][0] << 32) | self[:part_id][1]
      end

      def serial_no
        (self[:serial_no][0] << (32 * 3)) |
        (self[:serial_no][1] << (32 * 2)) |
        (self[:serial_no][2] << 32)       |
         self[:serial_no][3]
      end

    end
  end
end
