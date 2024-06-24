NB. Day 4: Scratchcards

sample =: 0 : 0
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
)

in =: fread 'input04'

NB. Part 1.
countWinning =: monad define
  nums =. (}.~ >:@(i.&':')) y
  splitIndex =. nums i. '|'
  winning =. ". (splitIndex-1) {. nums
  ours =. ". (splitIndex+1) }. nums
  +/ ours (e."0 1) winning
)
cardScore =: monad define
  c =. countWinning y
  (c>0)*2^(c - 1)
)
+/ cardScore ;._2 in NB. solution

NB. Part 2.
part2 =: monad define
  NB. Makes heavy use of folding. The accumulator keeps track
  NB. of how many copies there are of the remaining tickets. If
  NB. there are C copies of a ticket and it has N winning numbers,
  NB. then we add C to the next N items in the accumulator.
  cs =. countWinning ;._2 y
  f =. {{ ((<: # y) {. (x $ {. y)) + (}. y) }}
  >: +/ ({."1) ((# cs) $ 1) ]F:. f cs
)
