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
NB. Can't just put '5' because it'd be a scalar, not an array!
ranks =: (1 $ 5); 4 1; 3 2; 3 1 1; 2 2 1; 2 1 1 1; 5 $ 1
handKey =: {{ (ranks i. < \:~ #/.~ y) ; ('AKQJT98765432' (i."_ 0) y) }}
part1 =: monad define
  rounds =. (' '&splitstring) ;._2 y
  bids =. > ". each , {:"1 rounds
  ordering =. \: handKey"1 >"0 {."1 rounds
  +/ (>: i. $ bids) * (ordering { bids)
)

NB. Part 2
bestPossibleHand =: monad define
  NB. TODO
  NB. Generate all the possible hands
  NB. Find their ranks
  NB. Pick the lowest
  NB. This gives the rank of an individual hand:
  (ranks i. < \:~ #/.~ y)
)
handKey2 =: {{ (bestPossibleHand y) ; ('AKQJT98765432' (i."_ 0) y) }}
part2 =: monad define
  rounds =. (' '&splitstring) ;._2 y
  bids =. > ". each , {:"1 rounds
  ordering =. \: handKey2"1 >"0 {."1 rounds
  +/ (>: i. $ bids) * (ordering { bids)
)
