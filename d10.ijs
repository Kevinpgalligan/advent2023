NB. Day 10: Pipe Maze

in =: fread 'input10'
sample =: 0 : 0
-L|F7
7S-7|
L|7||
-L-J|
L|-JF
)
sample2 =: 0 : 0
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
)

getOffsets =: monad define
  if. y = '|' do. (,: 1 0) , _1 0
  elseif. y = '-' do. (,: 0 1) , 0 _1
  elseif. y = 'L' do. (,: _1 0) , 0 1
  elseif. y = 'J' do. (,: _1 0) , 0 _1
  elseif. y = '7' do. (,: 1 0) , 0 _1
  elseif. y = 'F' do. (,: 1 0) , 0 1
  else. 0 0 $ 0
  end.
)
nextCoords =: dyad define
  NB. Given pipe type ('|', ',', 'L', ...) and coordinates, returns
  NB. coordinates of connected tiles.
  y +"1 1 getOffsets x
)
idxify =: monad define
  <"1 <"0 y
)
get2d =: dyad define
  (idxify x) { y
)

part1 =: monad define
  grid =. , ;._2 y
  width =. {: $ grid
  start =. (<.@(%&width) , width&|) (, grid) i. 'S'
  NB. Assuming the start position isn't at the edge.
  surrounding =. (_2 ,\ 0 1 0 _1 1 0 _1 0) +"1 1 start
  NB. Use this mask to pick the two surrounding tiles that connect to start.
  NB. E.g. to connect to start, a tile to the east must be -, J or 7.
  mask =. (_3 ,\ ; '-J7' ; '-FL' ; 'LJ|' ; '7F|') e.~"1 0 (idxify surrounding) { grid
  NB. Mark the start tile as visited, to start.
  visited =. 1 (idxify start)} ($ grid) $ 0

  keepGoing =. {{
    'queue maxDist visited' =. y
    0 < # queue
  }}
  rec =. {{
    grid =. x
    'queue maxDist visited' =. y
    'dist cur'  =. {. queue
    if. (idxify cur) { visited do.
      (}. queue) ; maxDist ; visited
    else.
      NB. Filter out neighbouring tiles we've already visited.
      next =. (#~ -.@(get2d&visited)"1) (cur get2d grid) nextCoords cur
      NB. Add 1 to distance to next tiles, pick max distance, and set current
      NB. tile to visited.
      NB. (Well, should only be 1 next tile, but trying to be general...)
      ((}. queue) , ((>:dist)&;)"1 next) ; (dist >. maxDist) ; 1 (idxify cur)} visited
    end.
  }}
  1 {:: ((grid&rec)^:keepGoing^:_) ((1&;)"1 mask # surrounding) ; 0 ; visited
)
