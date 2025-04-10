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
isStartState =: {{ 'A' = {: y }}
isEndState =: {{ 'Z' = {: y }}
part2 =: monad define
  lines =. LF splitstring y
  dirs =. > {. lines
  mapRaw =. }: 2 }. lines
  map =. _3 ,\ ; parseNodeSpec each mapRaw
  keepGoing =. {{
    'curr i dirs map' =. y
    *./ ; isEndState each curr
  }}
  NB. TODO:
  NB.   1. modify rec to handle list of states.
  NB.   2. modify initial value for 'curr' so that it's list of start states
  NB.   3. (optional) remove duplicate states after each round of transitions
  rec =. {{
    'curr i dirs map' =. y
    row =. , (#~ ((curr&-:) @ (0&{::))"1) map
    newCurr =. ('R' = ((# dirs) | i) { dirs) {:: }. row
    newCurr ; (>: i) ; dirs ; < map
  }}
  1 {:: (rec^:keepGoing^:_) 'AAA' ; 0 ; dirs ; < map
)
