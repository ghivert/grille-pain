-module(unsafe_ffi).

-export([coerce/1]).

coerce(A) ->
  A.
