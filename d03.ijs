NB. Day 3: Gear Ratios
NB. https://adventofcode.com/2023/day/3

load 'regex'

in =: fread 'input03'
sample =: 0 : 0
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
)

dumb =: 0 : 0
6..3
....
*...
10.1
)

NB. Part 1.
isNum =: {{ *./ +/"1 y (E."0 1) '0123456789' }}
isSymbol =: isNum +: ('.'&-:)

NB. Rather than working with 2d coordinates, we add/sub the width
NB. to an index to get adjacent items.
getNeighbours =: dyad define
  w =. {: $ x
  l =. */ $ x
  NB. Check if away from edges.
  le =. (w | y ) > 0
  re =. (w | y) < (w-1)
  te =. y >: w
  be =. (y+w) < l
  neighs =. 0 $ 0
  NB. There has to be a better/more functional way to do this...
  if. le do. neighs =. neighs,(y-1) end.
  if. re do. neighs =. neighs,(y+1) end.
  if. te do.
    neighs =. neighs,(y-w)
    if. re do. neighs =. neighs,((y-w)+1) end.
    if. le do. neighs =. neighs,((y-w)-1) end.
  end.
  if. be do.
    neighs =. neighs,(y+w)
    if. re do. neighs =. neighs,((y+w)+1) end.
    if. le do. neighs =. neighs,((y+w)-1) end.
  end.
  neighs
)

          
NB. NOTE TO FUTURE SELF.
NB. This somehow gets the right answer for the sample case
NB. but fails a much simpler test case that I made myself.
NB. (See: `dumb`, above).
NB. It's also returning an index error for the real input.
NB. I originally thought that it might be due to my misunderstanding
NB. of how free variables are handled in J, and there was data from the
NB. sample case leaking into my test case, but now I'm not so sure.
NB. Need to debug the test case and see what's happening.

part1 =: monad define
  NB. Pad each row with a dot so that nums don't overlap when
  NB. the grid is collapsed down to 1d.
  grid_p1_ =. ('.'"_ , (,&'.'))"1 > }: LF splitstring y
  s_p1_ =. '' joinstring (<"1) grid_p1_
  NB. Get the numbers.
  ns =. > ". each '[0-9]+' rxall s_p1_
  NB. Find where numbers are and check if each of them touches a symbol.
  ms =._2 ,\  , '[0-9]+' rxmatches s_p1_
  nextToSymbol =. {{ +./ (isSymbol"0) (grid_p1_ getNeighbours y) { s_p1_ }}
  isPart =. {{ +./ (nextToSymbol"0) ({. y) + i. ({: y) }}
  +/ (isPart"1 ms) # ns
)
