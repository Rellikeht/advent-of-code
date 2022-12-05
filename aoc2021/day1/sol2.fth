variable counter
variable prev

0 counter !
0 prev !

: readc key 48 - dup dup 0 >= swap 9 <= and ;
: addc if swap 10 * + false else drop true then ;
: readn 0 begin readc addc until ;

: chw < if counter @ 1 + counter ! then ;

\ a b c
\ a b c b c
\ a b c d
\ c d a b
\ c a b d
\ c b d a
\ c b e
\ b e c
\ b c e
: prevc 2dup + 2swap rot rot + rot swap ;

\ c b e
\ c b e f
\ c b e f
\ c b f e
\ c b f e e
\ c b f e
\ c b g
: upw prevc prev @ swap dup prev ! chw readn ;

: deb .s prev @ . cr ;
: nums readn readn readn prevc prev ! readn begin upw dup 0 = until ;

nums counter @ . cr bye
