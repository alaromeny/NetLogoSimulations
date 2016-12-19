


to setup
  clear-all
  reset-ticks
  setup-patches

end

to setup-patches

  ask patches [

    let colour random 100
    if colour < white-probability [
      set pcolor white
    ]
  ]

end


to go
  ask patches [
    check-neighbours
  ]
  tick
end

to check-neighbours

  let c 0
  ask neighbors [
    if pcolor = white [
      set c c + 1
    ]
  ]

  ifelse c = 0 [
    set pcolor white
  ][
    set pcolor black
  ]

end

to random-mutation

  let ran random 101
  if ran > mutation-probability [
    ifelse pcolor = white [
      set pcolor black
    ][
      set pcolor white
    ]
  ]

end