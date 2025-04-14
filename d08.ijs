NB. Day 8: Haunted Wasteland

in =: fread 'input08'

sample =: 0 : 0
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
)

parseNodeSpec =: monad define
  name =. ' =' taketo y
  (< name) , (', ' splitstring }: '(' takeafter y)
)

part1 =: monad define
  lines =. LF splitstring y
  dirs =. > {. lines
  mapRaw =. }: 2 }. lines
  map =. _3 ,\ ; parseNodeSpec each mapRaw
  keepGoing =. {{ NB. this determines when to stop
    'curr i dirs map' =. y
    -. curr -: 'ZZZ' NB. continue if current is not ZZZ
  }}
  rec =. {{ NB. this moves to next node
    'curr i dirs map' =. y
    NB. Find matching row for current node.
    row =. , (#~ ((curr&-:) @ (0&{::))"1) map
    newCurr =. ('R' = ((# dirs) | i) { dirs) {:: }. row
    newCurr ; (>: i) ; dirs ; < map
  }}
  1 {:: (rec^:keepGoing^:_) 'AAA' ; 0 ; dirs ; < map
)

NB. For part 2, instead of storing a single current state, we need
NB. multiple states. Represented as an array of boxed strings.
NB. Note: A brute force attempt seems to run indefinitely. This
NB.       suggests that maybe a smarter approach is needed.
NB.       Assuming there isn't a bug in my code, and assuming my code isn't taking
NB.       forever because it's inefficient, an alternative approach
NB.       might be to independently follow the path of each state until it
NB.       enters a loop. Find the earliest end state in that loop. Find the length
NB.       of the loop. Then get the lowest common multiple of all the loop lengths.
NB.       A bit finnicky, though.
isStartState =: {{ 'A' = {: y }}
isEndState =: {{ 'Z' = {: y }}

part2 =: monad define
  lines =. LF splitstring y
  dirs =. > {. lines
  mapRaw =. }: 2 }. lines
  map =. _3 ,\ ; parseNodeSpec each mapRaw
  keepGoing =. {{
    'curr i dirs map' =. y
    -. *./ ; isEndState each curr
  }}
  rec =. {{
    'curr i dirs map' =. y
    rows =. (#~ ((e.&curr) @ {.)"1) map
    newCurr =. , ('R' = ((# dirs) | i) { dirs) {"_ 1 }."1 rows
    newCurr ; (>: i) ; dirs ; < map
  }}
  startStates =. (#~ (isStartState@>)"0) , {."1 map
  1 {:: (rec^:keepGoing^:_) startStates ; 0 ; dirs ; < map
)
