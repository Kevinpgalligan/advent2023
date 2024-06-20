NB. Day 1: Trebuchet?!
NB. https://adventofcode.com/2023/day/1

NB. Part 1.
NB. Read file. Change to the same directory first.
s =. 1!:1 <'input01'
NB. This extracts the first digit.
digit =. monad define
  {. (#~ (+./ @: ('0123456789'&(E."0 1)))) y
)
NB. And this gives the solution.
+/ (". @: (digit , (digit@:|.))) ;._2 s

NB. Part 2.
DS =. ',' splitstring 'one,two,three,four,five,six,seven,eight,nine,0,1,2,3,4,5,6,7,8,9'
NB. The integer corresponding to each string.
NS =. (1 + i.9) , (i. 10)
digit =. monad define
  m =. (E.&y @: >)"0 DS
  n =. +/ NS * m
  m =. +./ m
  ". ({. , {.@:|.) (".^:_1)"0 m # n
)
+/ digit ;._2 s NB. The solution!
