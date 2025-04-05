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
  jokerMask =. 'J' = y
  counts =. \:~ #/.~ (-. jokerMask) # y
  NB. Best hand always comes from all jokers representing the highest-frequency
  NB. non-joker. Edge case when all 5 cards are jokers.
  if. (+/ jokerMask) -: 5 do.
    0 NB. 5-of-a-kind
  else.
    ranks i. < ((+/ jokerMask) + {. counts) , (}. counts)
  end.
)
handKey2 =: {{ (bestPossibleHand y) ; ('AKQT98765432J' (i."_ 0) y) }}
part2 =: monad define
  rounds =. (' '&splitstring) ;._2 y
  bids =. > ". each , {:"1 rounds
  ordering =. \: handKey2"1 >"0 {."1 rounds
  +/ (>: i. $ bids) * (ordering { bids)
)
