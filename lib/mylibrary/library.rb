require 'ffi'

module MyLibrary
  extend FFI::Library
  ffi_lib 'lib/mylibrary/libsmart_plug_C.so'
  attach_function :LCD_1in3_test, [], :void
  attach_function :KEY_1in3_test, [], :void
end

