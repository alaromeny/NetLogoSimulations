patches-own [
  numNeighWalls          ;; This variable tracks the number of built patches in a patch's local area.
]

globals [
  numWalls               ;; This variable tracks the total number of built patches in the environment.
]

to setup
  clear-all
  reset-ticks
  setup-turtles
  setup-patches

end

;; his procedure initialises the turtles
to setup-turtles
  create-turtles number-of-agents
  ask turtles [
    set size 2
    set color yellow
    set shape "butterfly"
    setxy random-xcor random-ycor
  ]
end

;;This procedure initialises all local patch variables
to setup-patches
  ask patches [
    set numNeighWalls 0
    set pcolor black
    set-up-centre
  ]
end

;; This procedure sets up a square in the centre for the turtles to build around.
to set-up-centre
  if abs pxcor < 2 and abs pycor < 2 [
    set pcolor cyan
  ]

end


;; This procedure initialises all probabilities randomly from 0% to 100%
to randomize-itilias-probabilites

  set wall-with-0-ajoin random-float 100
  set wall-with-1-ajoin random-float 100
  set wall-with-2-ajoin random-float 100
  set wall-with-3-ajoin random-float 100
  set wall-with-4-ajoin random-float 100
  set wall-with-5-ajoin random-float 100
  set wall-with-6-ajoin random-float 100
  set wall-with-7-ajoin random-float 100
  set wall-with-8-ajoin random-float 100

end


;; This procedure initialises all probabilities randomly from 0% to 10%

to randomize-itilias-probabilites-low
  set wall-with-0-ajoin random-float 10
  set wall-with-1-ajoin random-float 10
  set wall-with-2-ajoin random-float 10
  set wall-with-3-ajoin random-float 10
  set wall-with-4-ajoin random-float 10
  set wall-with-5-ajoin random-float 10
  set wall-with-6-ajoin random-float 10
  set wall-with-7-ajoin random-float 10
  set wall-with-8-ajoin random-float 10
end


;; This procedure initialises all probabilities
;; to match those found in the Polistes wasp colonies.
to  polistes-probabilities
  set wall-with-0-ajoin 0
  set wall-with-1-ajoin 5.7
  set wall-with-2-ajoin 5.7
  set wall-with-3-ajoin 5.7
  set wall-with-4-ajoin 55
  set wall-with-5-ajoin 55
  set wall-with-6-ajoin 55
  set wall-with-7-ajoin 55
  set wall-with-8-ajoin 55
end


;; This is the go procedure, it manages turtle building and movement
;; as well as tracing each patches neighbouring patches and the total
;; number of red patches
to go
  ask turtles [
    move
    place-wall
  ]
  set numWalls 0
  ask patches [
    count-num-neighbouring-walls-manual
    track-num-walls-built
  ]

  tick
end


;; This procedure increments the global variable numWalls when a patch is nest wall.
to track-num-walls-built
  if pcolor = red or pcolor = cyan[
    set numWalls numWalls + 1
  ]
end

;; This procedure adds a little 'wiggle' into the turtles movement
;; so that they do not constatly move in a straight line.
to move
  let ran random 10
  let bin random 3
  if bin = 1 [
    set heading heading + ran
    ]
  if bin = 2 [
    set heading heading - ran
  ]

  fd 0.5
end


;; this manages the placement of walls, using the probabilities associated
;; with each possible observed state of the envirnoment

to place-wall
  if numNeighWalls = 0[
    place-wall? wall-with-0-ajoin
  ]
  if numNeighWalls = 1[
    place-wall? wall-with-1-ajoin
  ]
  if numNeighWalls = 2[
    place-wall? wall-with-2-ajoin
  ]
  if numNeighWalls = 3[
    place-wall? wall-with-3-ajoin
  ]
  if numNeighWalls = 4[
    place-wall? wall-with-4-ajoin
  ]
  if numNeighWalls = 5[
    place-wall? wall-with-5-ajoin
  ]
  if numNeighWalls = 6[
    place-wall? wall-with-6-ajoin
  ]
  if numNeighWalls = 7[
    place-wall? wall-with-7-ajoin
  ]
  if numNeighWalls = 8[
    place-wall? wall-with-8-ajoin
  ]

end


;; This procedure takes in a percentage probability
;; and places a wall based on that
to place-wall? [percentage]
  let rand random-float 101

  if rand < percentage and pcolor = black[
    set pcolor red
  ]
end



;; Hard coded to look at all 8 surounding patches
;; and counts how many of these are nest walls.
;; Then saves this as a value local to this patch.
;; unfortunately in-radius 1 give 4 at NESW rather than all 8.
to count-num-neighbouring-walls-manual

  let countWalls 0

  ask patch-at 0  1 [
    if pcolor = red or pcolor = cyan [
      set countWalls countWalls + 1
    ]
  ]
  ask patch-at 0 -1 [
    if pcolor = red or pcolor = cyan[
      set countWalls countWalls + 1
    ]
  ]

  ask patch-at -1 -1 [
    if pcolor = red or pcolor = cyan[
      set countWalls countWalls + 1
    ]
  ]
  ask patch-at -1  0 [
    if pcolor = red or pcolor = cyan[
      set countWalls countWalls + 1
    ]
  ]
  ask patch-at -1  1 [
    if pcolor = red or pcolor = cyan[
      set countWalls countWalls + 1
    ]
  ]

  ask patch-at 1  1 [
    if pcolor = red or pcolor = cyan[
      set countWalls countWalls + 1
    ]
  ]
  ask patch-at 1  0 [
    if pcolor = red or pcolor = cyan[
      set countWalls countWalls + 1
    ]
  ]
  ask patch-at 1 -1 [
    if pcolor = red or pcolor = cyan[
      set countWalls countWalls + 1
    ]
  ]

  set numNeighWalls countWalls

end