breed [enemies enemy]
breed [bees      bee]

bees-own[
  right?
  seen-enemy?
  sensed-pheromone?

]

patches-own[
  chemical
]


to setup
  clear-all
  init-turtles
  reset-ticks

end


to init-turtles

  create-bees number-of-agents
  create-enemies 1
  ask bees [
    set size 2
    set color yellow + 1
    set shape "butterfly"
    setxy random-xcor random-ycor
    set seen-enemy?  False
    set right?  False
    set sensed-pheromone? False
  ]
  ask enemies [
    set size 2
    set shape "bug"
    setxy 0 0
    set color red
  ]

end

to manage-chemicals
  set pcolor scale-color green chemical 0.1 5
  set chemical chemical * diffusionRate
end


to go

  ask bees[
    ifelse seen-enemy?[
      wiggle
      release-pheromones
    ][

      sense-pheromone
      find-enemy
    ]
  ]
  diffuse chemical 0.5
  ask patches [
    manage-chemicals
  ]
  tick
  wait 0.2
end

to wiggle
  ifelse right?[
    rt random 30
    set right? False
  ][
    lt random 30
    set right? True
  ]
end

to move
  rt random 45
  lt random 45
  fd 1
end

to release-pheromones
  set chemical chemical + 50
end

to sense-pheromone
  let sense-right1 sense-pheromones-at 30 1
  let sense-ahead1 sense-pheromones-at  0 1
  let sense-left1 sense-pheromones-at -30 1
  let sense-right2 sense-pheromones-at 30 2
  let sense-ahead2 sense-pheromones-at  0 2
  let sense-left2 sense-pheromones-at -30 2
  let sense-right3 sense-pheromones-at 30 3
  let sense-ahead3 sense-pheromones-at  0 3
  let sense-left3 sense-pheromones-at -30 3

  let rtse sense-right1 + sense-right2 + sense-right3
  let ahse sense-ahead1 + sense-ahead2 + sense-ahead3
  let lfse sense-left1 + sense-left2 + sense-left3

  ifelse rtse > 0 or ahse > 0 or lfse > 0[
    set sensed-pheromone? True
    ifelse rtse > ahse or lfse > ahse [
      ifelse rtse > lfse[
        rt 30
        if sense-right3 > sense-right1 or sense-right2 > sense-right1[
          fd 1
        ]
      ][
        lt 30
        if sense-left3 > sense-left1 or sense-left2 > sense-left1[
          fd 1
        ]
      ]
    ][
      if sense-ahead3 > sense-ahead1 or sense-ahead2 > sense-ahead1[
        fd 1
      ]
    ]
  ][
    set sensed-pheromone? False
    move
  ]



end


to-report sense-pheromones-at [angle dist]
  let p patch-right-and-ahead angle dist
  if p = nobody [
    report 0
  ]
  report [chemical] of p
end


to find-enemy
  let sense-ahead1 (patch-set  patch-ahead 1 patch-right-and-ahead 30 1)
  let sense-ahead2 (patch-set patch-left-and-ahead 30 2 patch-ahead 2 patch-right-and-ahead 30 2)
  let sense-ahead3 (patch-set patch-left-and-ahead 30 3 patch-ahead 3 patch-right-and-ahead 30 3)

  ifelse any? enemies-on patch-left-and-ahead 30 1 [
    lt 30
    set seen-enemy? True
  ][
    ifelse any? enemies-on patch-right-and-ahead 30 1 [
      rt 30
      set seen-enemy? True
    ][
      ifelse any? enemies-on patch-ahead 1 [
        set seen-enemy? True
      ][
        ifelse any? enemies-on patch-left-and-ahead 30 2 [
          lt 30
          fd 1
          set seen-enemy? True
        ][
          ifelse any? enemies-on patch-right-and-ahead 30 2 [
            rt 30
            fd 1
            set seen-enemy? True
          ][
            ifelse any? enemies-on patch-ahead 2 [
              fd 1
              set seen-enemy? True
            ][
              ifelse any? enemies-on patch-left-and-ahead 30 3 [
                lt 30
                fd 2
                set seen-enemy? True
              ][
                ifelse any? enemies-on patch-right-and-ahead 30 3 [
                  rt 30
                  fd 2
                  set seen-enemy? True
                ][
                  ifelse any? enemies-on patch-ahead 3 [
                    fd 2
                    set seen-enemy? True
                  ][

                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ]
  ]

end