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

sample2 =: 0 : 0
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
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

NB. First attempt at part 2. A fairly straightforward tweak of part 1
NB. that deals with multiple states simultaneously.
NB. Finds correct answer for samples, but seems to run indefinitely for
NB. full input. (Well, I didn't try running it for more than a minute,
NB. could just be inefficient).
isStartState =: {{ 'A' = {: y }}
isEndState =: {{ 'Z' = {: y }}
part2_dud =: monad define
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

getNodeId =: monad define
  'curr steps dirs map' =. y
  i =. (# dirs) | steps
  i + (# dirs) * (, {."1 map) i. < curr
)
traverse =: dyad define
  'dirs map' =. x
  keepGoing =. {{
    'curr steps dirs map visited' =. y
    NB. Stop when have already visited this node.
    NB. ...node being the combination of the node
    NB. in the original network (like 'AAA') and the
    NB. index in the list of directions.
    -. 0 <: (getNodeId curr ; steps ; dirs ; < map) { visited 
  }}
  rec =. {{
    'curr steps dirs map visited' =. y
    id =. getNodeId curr ; steps ; dirs ; < map
    row =. , (#~ ((curr&-:) @ (0&{::))"1) map
    newCurr =. ('R' = ((# dirs) | steps) { dirs) {:: }. row
    newCurr ; (>: steps) ; dirs ; map ; (steps id } visited)
  }}
  'last steps blah blah visited' =. (rec^:keepGoing^:_) y ; 0 ; dirs ; map ; ((# dirs) * (# map)) $ _1
  NB. We ended up at the same "node" after `steps` steps. To get the loop
  NB. length, subtract the number of steps it took us to first get to this node.
  stepsToLoopStart =. (getNodeId last ; steps ; dirs ; < map) { visited
  loopLength =. steps - stepsToLoopStart
  NB. We also need to know the number of steps it takes to reach each of the
  NB. end nodes that were encountered. Generate all the end node IDs, index
  NB. into `visited`, and filter out any -1s (indicating "not visited").
  stepsToEndStates =. (#~ (>: 0:)) (, (i. # dirs) +"_ 0 (# dirs) * I. ; isEndState each , {."1 map) { visited
  stepsToLoopStart ; loopLength ; stepsToEndStates
)

part2 =: monad define
  lines =. LF splitstring y
  dirs =. > {. lines
  mapRaw =. }: 2 }. lines
  map =. _3 ,\ ; parseNodeSpec each mapRaw
  NB. Step 1: Individually traverse from each start node
  NB.         until it ends up in a loop. Store the loop
  NB.         length and the number of steps to reach each
  NB.         end state.
  startStates =. (#~ (isStartState@>)"0) , {."1 map
  ((dirs ; < map)&traverse) each startStates
  NB. Step 2: Use number theory magic to find the result.
  NB.         (I ended up doing this manually)
)

0 : 0
Work in progress, try to understand this and make sure
the values make sense. The steps to loop start seems wrong.

part2 sample2
    ┌───────┬─────────┐
    │┌─┬─┬─┐│┌─┬─┬───┐│
    ││1│2│2│││1│6│6 3││
    │└─┴─┴─┘│└─┴─┴───┘│
    └───────┴─────────┘

Hm, first one seems correct! It ends up in a loop after 1 step.
Loop length is 2. And it takes 2 steps to first end node.

11A L
11B R
11Z L
11B R

The second one...

22A L
22B R  enters loop (1 step, correct)
22C L  2
22Z R  3
22B L  4
22C R  5
22Z L  6
22B R  7  -- back to start in 6 steps! Correct.

And yes, it ends up in end nodes in steps 3 and 6.

It took quite a while to run on the full input, I wonder if I'm doing any wasteful copying...
But also, it's quite a lot of steps.

part2 in
    ┌───────────────┬───────────────┬───────────────┬───────────────┬───────────────┬───────────────┐
    │┌─┬─────┬─────┐│┌─┬─────┬─────┐│┌─┬─────┬─────┐│┌─┬─────┬─────┐│┌─┬─────┬─────┐│┌─┬─────┬─────┐│
    ││2│11567│11567│││2│19637│19637│││2│15871│15871│││6│21251│21251│││2│12643│12643│││3│19099│19099││
    │└─┴─────┴─────┘│└─┴─────┴─────┘│└─┴─────┴─────┘│└─┴─────┴─────┘│└─┴─────┴─────┘│└─┴─────┴─────┘│
    └───────────────┴───────────────┴───────────────┴───────────────┴───────────────┴───────────────┘

Assuming there isn't a bug... it seems like each path only ends up in a single end state!? Struggling
to understand why the loop length is the same as the number of steps to reach the end states.
I think that makes it more convenient?
If it takes L steps to reach start state, and loop is L steps, then we hit end state for each path at
all multiples of L. So just find LCM of all loop lengths. LCM is *./ in J, so the answer is...

*./ 11567 19637 15871 21251 12643 19099
)
