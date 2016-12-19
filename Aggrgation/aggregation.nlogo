turtles-own [neighCount desiredX desiredY]



;; This procedure is attached to the setup button
;; It cleans the area, and initialises the patches and turtles

to setup

  clear-all
  setup-patches
  setup-turtles
  reset-ticks

end

;;This procedure is attached to the go button
;;This is repeated in an infinite loop
to go
  calc-neighbours-centre
  move
  tick
end


;; This procedure sets all the patches to black
to setup-patches

  ask patches [ set pcolor black]

end

;; This procedure creates the number of turtles as set by the slider on the GUI
;; And initialises their pose to random poses in the environment.
to setup-turtles

  create-turtles number-of-agents
  ask turtles [setxy random-xcor random-ycor]

end

;; This procedure controls the movement of the turtles in the swarm
to move

  ask turtles[
    if desiredX = 0 and desiredY > 0 [ set heading 0]
    if desiredX > 0 and desiredY > 0 [ set heading 45]
    if desiredX > 0 and desiredY = 0 [ set heading 90]
    if desiredX > 0 and desiredY < 0 [ set heading 135]
    if desiredX = 0 and desiredY < 0 [ set heading 180]
    if desiredX < 0 and desiredY < 0 [ set heading 225]
    if desiredX < 0 and desiredY = 0 [ set heading 270]
    if desiredX < 0 and desiredY > 0 [ set heading 315]
    if desiredX != 0 or desiredY != 0 [ fd movement-increments]
  ]
end


;; This procedure calculates the centroid of the relative positions of a turtles neighbours.
to calc-neighbours-centre

  ask turtles [

    let i 0
    let n 0
    let x 0
    let y 0

    let candidates turtles in-radius-nowrap sensing-range
    set n (count candidates) - 1 ;; minus 1 as self is counted in candidates

    ask candidates [
      set x x + xcor
      set y y + ycor
    ]

    set x x - xcor  ;; minus xcor as self is counted in candidates
    set y y - ycor  ;; minus ycor as self is counted in candidates
    set x x - (n * xcor)
    set y y - (n * ycor)

    ifelse n > 0[
      set x x / n
      set y y / n
      set desiredX x
      set desiredY y
    ][
      set label "L"
      set desiredX 0
      set desiredY 0
    ]
  ]
end