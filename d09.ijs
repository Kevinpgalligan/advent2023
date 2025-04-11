NB. Day 9: Mirage Maintenance

in =: fread 'input09'
sample =: 0 : 0
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
)

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
  NB. Swap '-' for '_' so numbers are read properly.
  seqs =. (<@".) ;._2 ('-';'_') stringreplace y
  +/ > calc each seqs
)
