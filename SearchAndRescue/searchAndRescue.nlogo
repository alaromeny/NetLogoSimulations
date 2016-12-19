patches-own [
  chemical             ;; amount of chemical on this patch
  food                 ;; amount of food on this patch (0, 1, or 2)
  nest?                ;; true on nest patches, false elsewhere
  wall?                ;; true on walls, false elsewhere
  base?                ;; true on base, false elsewhere
  food?                ;;
  nest-scent           ;; number that is higher closer to the nest
  food-source-number   ;; number (1, 2, or 3) to identify the food sources
]

turtles-own [

  waypoint?            ;; is this turtle a waypoint?
  foundFood?           ;; has the turtle found some food?
  distToFood           ;; has the turtle found distance through landmarks to food
  pathToFood           ;; what is the distance of path to the food through landmarks
  communicated?
]


;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;


to setup
  clear-all
  set-default-shape turtles "bug"
  setup-arena
    create-turtles population
    [ set size robot-size         ;; easier to see
      set color pink
      place-robots
      initialise-turle-vars
    ]
  reset-ticks
end


;;this is a wrapper procedure to setup the evironment. It sets up the walls and base patches and colours them in
to setup-arena
  ask patches
  [ setup-wall
    setup-base
    setup-food-source
    colour-walls
  ]
end

to initialise-turle-vars
  set waypoint? False
  set foundFood? False
  set distToFood 999
  set pathToFood 999
  set communicated? False
end

;;this procedure sets up which patches will be walls.
to setup-wall

  ;;walls at the edges of the map
  set wall? pycor = 0
  set wall? wall? or pxcor = 0
  set wall? wall? or pycor = max-pycor
  set wall? wall? or pxcor = max-pxcor

  ;;wall around the nest??
  ;;set wall? wall? or(pycor = 25 and pxcor < 40)
  ;;set wall? wall? or (pycor < 15 and pxcor = 40)

end


;;this procedure sets up which patches will be the base.
to setup-base
  set base? (pycor < 25 and pxcor < 40)
end


to setup-food-source
  set food? (pycor > 90 and pxcor > 90)
  set food? food? or (pycor < 10 and pxcor > 90)
  set food? food? or (pycor > 90 and pxcor < 10)
end

;;this procedure sets wall patches to red and base patches to blue
to colour-walls
  if base?[
      set pcolor blue
  ]
  if food?[
      set pcolor cyan
  ]
  if wall?[
    set pcolor red
  ]
end

;; this procedure set the turtles initial x and y coordinates to be a random location in the base
to place-robots
  let randX random 37
  if randX < 3 [
    set randX 5
  ]
  let randY random 23
  if randY < 3 [
    set randY 5
  ]
  setxy randX randY
end


;;;;;;;;;;;;;;;;;;;;;
;;; Go procedures ;;;
;;;;;;;;;;;;;;;;;;;;;




to go  ;; forever button
  ask turtles[
    turtle-state-machine
  ]
  tick
end


to turtle-state-machine

  if pcolor = blue[
    leave-base
  ]

  if pcolor = black[
    if waypoint? = False [
      roam-state
    ]
    if waypoint?[
      communicate-state
    ]
  ]
  if pcolor = cyan [
    set color white
  ]
end


to roam-state
  sense-food
  sense-waypoint
  color-turte
  if waypoint? = False [
    random-walk
  ]
end

to communicate-state
  communicate-locally
  color-turte
end


;;this procedure allows the turtles to randomly walk around avoiding walls.

to leave-base

  let foundWall False
  let i 1


  while [i <= wall-sense-threshold][
    let patchAhead patch-ahead i
    if [pcolor] of patchAhead = red[
      set foundWall True
    ]
    set i i + i
  ]


  ifelse foundWall [
    right random 360
    leave-base
  ][
    forward robot-speed
  ]

end


;;this procedure allows the turtles to randomly walk around avoiding walls.

to random-walk

  let foundWall False
  let i 1


  while [i <= wall-sense-threshold][
    let patchAhead patch-ahead i
    if [pcolor] of patchAhead = red or [pcolor] of patchAhead = blue[
      set foundWall True
    ]
    set i i + i
  ]


  ifelse foundWall [
    right random 360
    random-walk
  ][
    forward robot-speed
  ]
end

to color-turte
  become-normal-waypoint
  become-coms-waypoint
  become-food-waypoint
end


to become-normal-waypoint
  if waypoint? [
    set color yellow
    set label "W"
  ]
end

to become-food-waypoint
  if foundFood? [
    set color green
    set label "F"
  ]
end


to become-coms-waypoint
  if communicated? [
    set color turquoise
    set label round (pathToFood)
  ]
end


to communicate-locally
  let local-turtles turtles in-radius-nowrap communication-range
  let dist 999
  let myX xcor
  let myY ycor
  let theirX 0
  let theirY 0
  let foundPath False

  ask local-turtles [
    if waypoint? [

      if foundFood? or communicated? [

        let tmpdist get-Distance myX myY xcor ycor
        set tmpdist tmpdist + pathToFood

        if tmpdist < dist[

          set dist tmpdist
          set theirX xcor
          set theirY ycor
          set foundPath True
        ]
      ]
    ]
  ]
  if foundPath [
    set pathToFood dist
    set communicated? True
  ]
end



to sense-waypoint
  let local-turtles turtles in-radius-nowrap sensing-range
  let waypointFound? 0
  let myX xcor
  let myY ycor
  let dist 999

  ask local-turtles [
    if waypoint? [

      set waypointFound? waypointFound? + 1
      let tmpdist get-Distance myX myY xcor ycor

      if tmpdist < dist[
        set dist tmpdist
      ]
    ]
  ]

  if waypointFound? = 0 [
    set waypoint? True
  ]
end


to-report get-Distance [myX myY theirX theirY]

  let deltax myX - theirX
  let deltay myY - theirY

  set deltax abs deltax
  set deltay abs deltay

  let hyp ((deltax * deltax) + (deltay * deltay))
  report sqrt hyp


end


to sense-food
  let local-patches patches in-radius-nowrap sensing-range
  let foodFoundNear False
  let x 0
  let y 0

  ask local-patches [
    if food? [
      set foodFoundNear True
      set x pxcor
      set y pycor
    ]
  ]
  if foodFoundNear [
    set distToFood get-Distance xcor ycor x y
    set pathToFood distToFood
    set foundFood? True
    set waypoint? True
  ]
end