require 'ffi'

module FFI
  module HackRF
    extend FFI::Library

    ffi_lib 'hackrf'

    enum :hackrf_error, [
      :success, 0,
      :true, 1,
      :invalid_param, -2,
      :not_found, -5,
      :busy, -6,
      :no_mem, -11,
      :libusb, -1000,
      :thread, -1001,
      :streaming_thread_err, -1002,
      :streaming_stopped, -1003,
      :streaming_exit_called, -1004,
      :other, -9999
    ]

    enum :hackrf_board_id, [
      :jellybean , 0,
      :jawbreaker, 1,
      :hackrf_one, 2,
      :invalid,    0xff
    ]

    enum :rf_path_filter, [
      :bypass,     0,
      :low_pass,   1,
      :high_pass,  2
    ]

    callback :hackrf_sample_block_cb_fn, [:pointer], :int

    attach_function :hackrf_init, [], :int
    attach_function :hackrf_exit, [], :int

    attach_function :hackrf_open, [:pointer], :int
    attach_function :hackrf_close, [:pointer], :int
    
    attach_function :hackrf_start_rx, [:pointer, :hackrf_sample_block_cb_fn, :pointer], :int, blocking: true
    attach_function :hackrf_stop_rx, [:pointer, :hackrf_sample_block_cb_fn, :pointer], :int

    attach_function :hackrf_start_tx, [:pointer, :hackrf_sample_block_cb_fn, :pointer], :int, blocking: true
    attach_function :hackrf_stop_tx, [:pointer, :hackrf_sample_block_cb_fn, :pointer], :int

    # return HACKRF_TRUE if success
    attach_function :hackrf_is_streaming, [:pointer], :int
    attach_function :hackrf_max2837_read, [:pointer, :uint8, :pointer], :int
    attach_function :hackrf_max2837_write, [:pointer, :uint8, :uint16], :int

    attach_function :hackrf_si5351c_read, [:pointer, :uint16, :pointer], :int
    attach_function :hackrf_si5351c_write, [:pointer, :uint16, :uint16], :int

    attach_function :hackrf_set_baseband_filter_bandwidth, [:pointer, :uint32], :int

    attach_function :hackrf_rffc5071_read, [:pointer, :uint8, :pointer], :int
    attach_function :hackrf_rffc5071_write, [:pointer, :uint8, :uint16], :int

    attach_function :hackrf_spiflash_erase, [:pointer], :int
    attach_function :hackrf_spiflash_write, [:pointer, :uint32, :uint16, :buffer_in], :int
    attach_function :hackrf_spiflash_read, [:pointer, :uint32, :uint16, :buffer_out], :int

    # device will need to be reset after hackrf_cpld_write
    attach_function :hackrf_cpld_write, [:pointer, :buffer_in, :uint], :int

    attach_function :hackrf_board_id_read, [:pointer, :pointer], :int
    attach_function :hackrf_version_string_read, [:pointer, :pointer, :uint8], :int

    attach_function :hackrf_set_freq, [:pointer, :uint64], :int
    attach_function :hackrf_set_freq_explicit, [:pointer, :uint64, :uint64, :rf_path_filter], :int

    # currently 8-20Mhz - either as a fraction, i.e. freq 20000000hz divider 2 -> 10Mhz or as plain old 10000000hz (double)
    # preferred rates are 8, 10, 12.5, 16, 20Mhz due to less jitter
    attach_function :hackrf_set_sample_rate_manual, [:pointer, :uint32, :uint32], :int
    attach_function :hackrf_set_sample_rate, [:pointer, :double], :int

    # external amp, bool on/off
    attach_function :hackrf_set_amp_enable, [:pointer, :uint8], :int

    attach_function :hackrf_board_partid_serialno_read, [:pointer, :pointer], :int

    # range 0-40 step 8db
    attach_function :hackrf_set_lna_gain, [:pointer, :uint32], :int

    # range 0-62 step 2db
    attach_function :hackrf_set_vga_gain, [:pointer, :uint32], :int

    # range 0-47 step 1db
    attach_function :hackrf_set_txvga_gain, [:pointer, :uint32], :int

    # antenna port power control
    attach_function :hackrf_set_antenna_enable, [:pointer, :uint8], :int

    attach_function :hackrf_error_name, [:hackrf_error], :string
    attach_function :hackrf_board_id_name, [:hackrf_board_id], :string
    attach_function :hackrf_filter_path_name, [:rf_path_filter], :string

    # Compute nearest freq for bw filter (manual filter)
    attach_function :hackrf_compute_baseband_filter_bw_round_down_lt, [:uint32], :uint32
    # Compute best default value depending on sample rate (auto filter)
    attach_function :hackrf_compute_baseband_filter_bw, [:uint32], :uint32
  end
end
