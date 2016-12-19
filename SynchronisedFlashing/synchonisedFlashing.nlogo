turtles-own [
  tickCount
  currentTicks
  on?
  myOffset
  corrected?


  clock
  threshold
  reset-level
  window
]

;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;
;; Setup Functions ;;
;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;


to setup
  clear-all
  init-turtles
  reset-ticks
end



to init-turtles
  create-turtles number-of-agents

  ask turtles [
    set size 4
    set shape "fish"
    setxy random-xcor random-ycor
    set clock random (round cycle-length)
    set threshold flash-length
    set reset-level 0
    set window threshold + delay
    flipLight
  ]

end


;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;
;;  Go Functions  ;;
;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;


to go

  ask turtles[
    if clock >= window[
      sense-neighbours
    ]
  ]
  ask turtles[
    increment-clock
    flipLight
  ]
  wait delay
  tick
end



to increment-clock
  set clock (clock + 1)
  if clock = cycle-length[
    set clock 0
  ]
end


to flipLight
  ifelse clock < threshold [
    set color lime + 3
    st
  ][
    set color lime - 3
    ht
  ]
end

to sense-neighbours

  let nearby-flies turtles in-radius sensing-limit
  let n-on-flies count nearby-flies with [color = lime + 3]
  let n-total count nearby-flies
  let perc n-on-flies / n-total
  if  perc >= threshold-to-reset [
    set clock reset-level
  ]


end