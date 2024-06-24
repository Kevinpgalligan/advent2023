NB. Day 7: Camel Cards

in =: fread 'input07'

sample =: 0 : 0
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
)

NB. Part 1.
ranks =: 5; 4 1; 3 2; 3 1 1; 2 2 1; 2 1 1 1; 5 $ 1
handKey =: {{ (ranks i. < \:~ #/.~ y) ; (/:~ 'AKQJT98765432' (i."_ 0) y) }}
part1 =: monad define
  rounds =. (' '&splitstring) ;._2 y
  ordering =. \: handKey"1 >"0 {."1 rounds
  +/ (>: i. (# ordering)) * ordering { > ". each , {:"1 rounds
)

NB. Part 2
NB. TODO
