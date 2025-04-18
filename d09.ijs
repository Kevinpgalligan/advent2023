NB. Day 9: Mirage Maintenance

in =: fread 'input09'
sample =: 0 : 0
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
)

NB. Swap '-' for '_' so numbers are read properly.
parseSeqs =: {{ (<@".) ;._2 ('-';'_') stringreplace y }}

calc =: monad define
  diffs =. {{
    if. *./ 0 = y do.
      1 Z: 1 NB. stop fold
    else.
      2 -/\ y
    end.
  }}
  ({: y) + +/ ({. F: diffs |. y)
)
part1 =: monad define
  seqs =. parseSeqs y
  +/ > calc each seqs
)

calc2 =: monad define
  diffs =. {{
    if. *./ 0 = y do.
      1 Z: 1
    else.
      2 -/\ y
    end.
  }}
  -/ ({. y) , ({: F: diffs |. y)
)
part2 =: monad define
  seqs =. parseSeqs y
  +/ > calc2 each seqs
)
