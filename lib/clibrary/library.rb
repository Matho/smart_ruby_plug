require 'ffi'

module CLibrary
  extend FFI::Library
  ffi_lib 'lib/clibrary/libsmart_plug_C.so'
  attach_function :LCD_redraw, [:int, :string, :string, :int, :int], :void
  attach_function :KEY_listen, [:int], :int
end

