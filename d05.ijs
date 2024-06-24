NB. Day 5: If You Give A Seed A Fertilizer

in =: fread 'input05'

NB. Part 1.
inRange =: {{ ((1 { y) <: x) * (x <: (+/ }. y) ) }}
mapToNext =: dyad define
  m =. x (inRange"0 1) y
  if. +./m do. (((x&-)@(1&{)) + {.) , m # y else. x end.
)
part1 =: monad define
  sections =. (LF , LF) splitstring y
  seeds =. ". (}.~ >:@(i.&':')) > {. sections
  parseMap =. {{ ". ;._1 LF , (}.~ >:@(i.&LF)) y }}
  maps =. parseMap each }. sections
  <./ seeds ]F.. {{ y (mapToNext"0 _) >x }} maps
)

NB. Part 2.
NB. TODO
NB. Have to consider ranges of seed values. So we have an N x 2 array at
NB. step. Each range, when mapped, can output multiple new ranges. SO, need
NB. to output a list of boxes, each box containing multiple ranges. Then just
NB. remove a layer of boxing.
