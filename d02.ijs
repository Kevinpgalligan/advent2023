NB. Day 2: Cube Conundrum.
NB. https://adventofcode.com/2023/day/2

s =: fread 'input02'

NB. Part 1.
N =: 12 13 14
C =: 'red'; 'green'; 'blue'
NB. Takes '2 red' and returns (2 0 0).
getCount =: {{ (".@>@[ * (C&(-:"0 0))@])/ ;: y }}
NB. Takes '1 red, 0 green, 10 blue' and returns (1 0 10).
getCounts =: {{ +/ > getCount each ', ' splitstring y }}
maxCounts =: {{ >./ > getCounts each '; ' splitstring y }}
lineScore =: monad define
  NB. Example line:
  NB.   Game 1: 2 green, 12 blue; 6 red, 6 blue
  a =. ': ' splitstring y
  gameId =. ". > {: ;: > {. a
  gameId * *./ N >: maxCounts > {: a
)
+/ lineScore ;._2 s

NB. Part 2.
linePower =: {{ */ maxCounts > {: ': ' splitstring y }}
+/ linePower ;._2 s
