NB. Day 3: Gear Ratios
NB. https://adventofcode.com/2023/day/3

load 'regex'

s =: fread 'input03'
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

NB. Part 1.
isNum =: {{ *./ +/"1 y (E."0 1) '0123456789' }}
isSymbol =: isNum +: ('.'&-:)
          
part1 =: monad define
  grid =. > }: LF splitstring y
  NB. Get the numbers.
  getValue =: {{ ((0: ` ".) @. (isNum y)) y }}
  ns =. > getValue each (#~ ((0&<)@#@>)"0) '.' splitstring '.' joinstring <"1 grid
  NB. Find the symbols.
  symbolMap =. isSymbol"0 grid
  NB. Given coordinates, this says whether it's next to a symbol.
  neighbours =. {{  (< ($ y) (#~ (> *. (0&<:)@])) each (<"1) x (+"0 1) _1 0 1) { y }}
  nextToSymbol =. {{ +./ , (x neighbours y) }}
  NB. Convert regex output to start/end coordinates.
  NB. In the end we'll have a list of start/end coordinates.
  toStartEnd =. {. , +/
  m =. ('[0-9]+'&rxmatches) each <"1 grid
  nonEmpty =. (0&< @ # @ >) m
  nCoords =. > , ; (<"2) each (nonEmpty # i. # grid) ([ (,"0 0) >@]) each toStartEnd"1 each (nonEmpty # m)
  NB. Now identify which numbers are next to symbols (i.e. are parts). First we
  NB. need a function to generate all the coordinates between the start and end
  NB. points of a number.
  coordsBetween =. {{ ({. x) (,"0 0) ({: x) + (i. ({: y) - ({: x)) }}
  isPart =. {{ +./ ((nextToSymbol&symbolMap)"1) (x coordsBetween y) }}
  (nextToSymbol&symbolMap)"1 each coordsBetween/ each (<"2) nCoords
  NB. mask =. (isPart/)"2 nCoords
  NB. +/ mask # ns
)

