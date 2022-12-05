: readc key 48 - dup dup 0 >= swap 9 <= and ;
: addc if swap 10 * + false else drop true then ;
: readn 0 begin readc addc until ;

: nums 0 readn begin readn dup rot > if swap 1 + swap then dup 0 = until ;

nums drop . cr bye
