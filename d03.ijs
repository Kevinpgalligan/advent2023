NB. Day 3: Gear Ratios
NB. https://adventofcode.com/2023/day/3

load 'regex'
require 'printf'

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

NB. Part 1.
isNum =: {{ *./ +/"1 y (E."0 1) '0123456789' }}
isSymbol =: isNum +: ('.'&-:)
getCoords =: {{
  i =. <.({. y)%x
  j =. x | {. y
  2 2 $ i,j,i,(j + {: y)
}}
isNextToSym =: {{
  NB. x -- coordinates of a symbol.
  NB. y -- 2x2 coordinates representing start & end points of number
  isAdjacentRow =. 1 >: | ({. , y) - {. x
  isAdjacentCol =. (0 1 -: ({: x) <: _2 0 + ({:"1 y))
  isAdjacentRow *. isAdjacentCol
}}

part1 =: monad define
  NB. Add 1 for padding.
  width =. 1 + y i. LF
  NB. Remove newlines so they don't mess up the indexing.
  NB. Pad with dots to avoid numbers joining together.
  y =. ('.' joinstring LF splitstring y) , '.'
  NB. Get the numbers and their coordinates.
  ns =. > ". each '[0-9]+' rxall y
  matches =. _2 ,\  , '[0-9]+' rxmatches y
  coords =. width getCoords"0 1 matches
  NB. Get the symbol 2d coordinates.
  symCoords =. (<.@:(%&width) , width&|)"0 I. isSymbol"0 y
  NB. Now compare each symbol's coordinates to each number coordinates, use
  NB. this to select the right numbers, and sum.
  +/ (+./ symCoords (isNextToSym"1 2)/ coords) # ns
)

part2 =: monad define
  NB. This bit is all the same.
  width =. 1 + y i. LF
  y =. ('.' joinstring LF splitstring y) , '.'
  ns =. > ". each '[0-9]+' rxall y
  matches =. _2 ,\  , '[0-9]+' rxmatches y
  coords =. width getCoords"0 1 matches
  symCoords =. (<.@:(%&width) , width&|)"0 I. isSymbol"0 y
  NB. This is different.
  NB.  
  table =. symCoords (isNextToSym"1 2)/ coords
  +/ (*/)"1 ns {~ I."1 (((2&=)@:(+/))"1 table) # table
)
