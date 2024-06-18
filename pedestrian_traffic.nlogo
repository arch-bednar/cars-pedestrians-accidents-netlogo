globals [
  hour
  signals ;;array for all city signals
  car-spawn-points ;;array for all car sprawn points
  car-spawn-death-points ;;array for cars to die
  human-spawn-points ;;array for all human sprawn points
  mouse-coordinates
  p-colors
  signals-timer
  show-horizontal-signals
  show-outerhorizontal-signals
  clockwise-signals
  clockwise-outer-signals
  dies-w
  dies-e
  dies-s
  dies-n
  spawn-n
  spawn-e
  spawn-s
  spawn-w
]

breed [cars car]
breed [people person]

cars-own[
  alcohol_intoxication ;;
  anxiety
  direction ;it can be "e" -> eatern direction, "w" -> western direction, "n" -> north direction, "s" -> south direction
]

people-own[
  anxiety ;;procent
  direction ;it can be "e" -> eatern direction, "w" -> western direction, "n" -> north direction, "s" -> south direction
  spawn-at
  dies-at
  awaits-green
]

to go
  ;; Aktualizacja współrzędnych myszy
  if mouse-inside? [
    set mouse-coordinates (word "Mouse Coordinates: (" mouse-xcor ", " mouse-ycor ")")
  ]

  ; Wyświetlenie współrzędnych myszy na monitorze
  clear-drawing
  ;;display-mouse-coordinates

  ; Czekanie na następny krok
  if (signals-timer = 6)[
    change-signals
    set signals-timer 0
  ]

  ;print (mouse-coordinates)

spawn-person
  ask people[
   move-person
   ;print direction
  ]
  ;spawn-person
  tick
  set signals-timer signals-timer + 1
  ;print("signals timer")
  ;print(signals-timer)
  ;spawn-person
end


to setup
  set show-horizontal-signals false
  set show-outerhorizontal-signals false
  set signals-timer 0
  set dies-w 0
  set dies-e 0
  set dies-s 0
  set dies-n 0
  set spawn-n 0
  set spawn-e 0
  set spawn-s 0
  set spawn-w 0
  set mouse-coordinates "Mouse Coordinates: (N/A, N/A)"

  clear-all
  reset-ticks
  paint-streets
  paint-pedestrians-ways
;  paint-signals
  change-signals
  paint-pedestrian-crossing

  set p-colors [7 8]
  ;color-car-spawns
  ;color-car-death-points
  ;color-humans-spawn-points

  set-spawn-points

;  create-people 5 [
;   set shape "person"
;   set color red
;   move-to one-of patches
;  ]
  spawn-person

;  create-cars 5[
;   set shape "car"
;   set color yellow
;   move-to one-of patches
;  ]

;  let i random length car-spawn-points
;  print(item i car-spawn-points)
;  print(item 0 item i car-spawn-points )
;  print(item 1 item i car-spawn-points )
end

to start

end

;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;
;             SETUP SECTION
to paint-streets

  ask patches[
   set pcolor 64
  ]

  ask patches[

    ;;drawing streets
    if (pxcor = -1 or pxcor = 0) or (pycor = -1 or pycor = 0)[
      set pcolor gray
    ]

    if (pxcor > 0 ) and (pycor >= 8 and pycor <= 9)[
      set pcolor gray
    ]

    if (pxcor < -1 ) and (pycor <= -8 and pycor >= -9)[
      set pcolor gray
    ]

    if (pxcor >= 8 and pxcor <= 9 ) and (pycor < 0)[
      set pcolor gray
    ]

    if (pxcor >= -9 and pxcor <= -8 ) and (pycor > 0)[
      set pcolor gray
    ]
  ]
end

to paint-pedestrians-ways
  ask patches[
    if (pycor = 1) and not (pxcor = -9 or pxcor = -8 or pxcor = -1 or pxcor = 0) [
      set pcolor 7
    ]

    if (pycor = -2) and not (pxcor = -1 or pxcor = 0 or pxcor = 9 or pxcor = 8) [
      set pcolor 7
    ]

    if (pycor = -7) and (pxcor < -1) [
      set pcolor 7
    ]
    if (pycor = -10) and (pxcor < -1) [
      set pcolor 7
    ]

    if (pycor = 7) and (pxcor > 0) [
      set pcolor 7
    ]

    if (pycor = 10) and (pxcor > 0) [
      set pcolor 7
    ]

    if (pycor < -1) and (pxcor = 7)[
      set pcolor 7
    ]

    if (pycor < -1) and (pxcor = 10)[
      set pcolor 7
    ]

    if (pycor > 0) and (pxcor = -10)[
      set pcolor 7
    ]

    if (pycor > 0) and (pxcor = -7)[
      set pcolor 7
    ]

    if not (pycor = 0 or pycor = -1 or pycor = -8 or pycor = -9) and (pxcor = -2)[
      set pcolor 7
    ]

    if not (pycor = 0 or pycor = -1 or pycor = 8 or pycor = 9) and (pxcor = 1)[
      set pcolor 7
    ]
  ]
end

to paint-signals
  set signals [[-9 3] [-4 -1] [0 -4] [3 0] [-1 3] [3 9] [-4 -9] [9 -4]]

  ask patch -9 3[
    set pcolor green
  ]

  ask patch -4 -1[
    set pcolor red
  ]

  ask patch 0 -4[
    set pcolor green
  ]

  ask patch 3 0[
    set pcolor red
  ]

  ask patch -1 3[
    set pcolor green
  ]

  ask patch 3 9[
    set pcolor green
  ]

  ask patch -4 -9[
    set pcolor green
  ]

  ask patch 9 -4[
    set pcolor green
  ]
end

to paint-pedestrian-crossing
  ask patches[
   if (pxcor = -9 or pxcor = -8) and (pycor = 2)[
     set pcolor 8
    ]

   if (pxcor = -3) and (pycor = -1 or pycor = 0)[
     set pcolor 8
    ]

   if (pxcor = -1 or pxcor = 0) and (pycor = -3)[
     set pcolor 8
    ]

   if (pxcor = 2) and (pycor = -1 or pycor = 0)[
     set pcolor 8
    ]

   if (pxcor = -1 or pxcor = 0) and (pycor = 2)[
     set pcolor 8
    ]

   if (pxcor = 2) and (pycor = 8 or pycor = 9)[
     set pcolor 8
    ]

   if (pxcor = -3) and (pycor = -9 or pycor = -8)[
      set pcolor 8
    ]

   if (pxcor = 8 or pxcor = 9) and (pycor = -3)[
      set pcolor 8
    ]

;    if (pxcor < -10) and (pycor = 11)[
;     set pcolor 7
;    ]
  ]
end

to set-spawn-points
  set car-spawn-points[[-9 16][-1 16][-16 -1][-16 -9][0 -16][9 -16][16 9][16 0]]
  set car-spawn-death-points [[-8 16][0 16][-16 0][-16 -8][-1 -16][8 -16][16 8][16 -1]]
  set human-spawn-points [[-7 16][-10 16][1 16][-2 16][-16 1][-16 -2]
                          [-16 -7][-16 -10][-2 -16][1 -16][7 -16][10 -16]
                          [16 10][16 7][16 1][16 -2]]

end

to color-humans-spawn-points
  ;human-spawn-points [[-7 16][-10 16][1 16][-2 16][-16 1][-16 -2][-16 -7][-16 -10][-2 -16][1 -16][7 -16][10 -16][16 10][16 7][16 1][16 -2]]

   ask patches[
   if (pxcor = -7) and (pycor = 16)[
     set pcolor yellow
    ]

   if (pxcor = -10) and (pycor = 16)[
     set pcolor yellow
    ]

   if (pxcor = 1) and (pycor = 16)[
     set pcolor yellow
    ]

    if (pxcor = -2) and (pycor = 16)[
     set pcolor yellow
    ]

   if (pxcor = -16) and (pycor = 1)[
     set pcolor yellow
    ]

   if (pxcor = -16) and (pycor = -2)[
     set pcolor yellow
    ]

    if (pxcor = -16) and (pycor = -7)[
     set pcolor yellow
    ]

    if (pxcor = -16) and (pycor = -10)[
     set pcolor yellow
    ]

    if (pxcor = -2) and (pycor = -16)[
     set pcolor yellow
    ]

    if (pxcor = 1) and (pycor = -16)[
     set pcolor yellow
    ]

    if (pxcor = 7) and (pycor = -16)[
     set pcolor yellow
    ]

    if (pxcor = 10) and (pycor = -16)[
     set pcolor yellow
    ]

    if (pxcor = 16) and (pycor = 10)[
     set pcolor yellow
    ]

    if (pxcor = 16) and (pycor = 7)[
     set pcolor yellow
    ]

    if (pxcor = 16) and (pycor = 1)[
     set pcolor yellow
    ]

    if (pxcor = 16) and (pycor = -2)[
     set pcolor yellow
    ]
  ]
end
;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;
;            END SETUP SECTION

to spawn-person
;    set human-spawn-points [[-7 16][-10 16][1 16][-2 16]
;  [-16 1][-16 -2][-16 -7][-16 -10]
;  [-2 -16][1 -16][7 -16][10 -16]
;                          [16 10][16 7][16 1][16 -2]]

  let i random length human-spawn-points

  ;aquiring x and y from sublist human-spawn-points[i]
  let x item 0 item i human-spawn-points
  let y item 1 item i human-spawn-points

  let dir random 4
  let spawn-chance random 4 + 1

  (ifelse
    (dir = 0)[
      if (spawn-chance <= spawn-person-n * 4)[
        create-people person-per-tick[
          let tab [-7 1 -2 -10]
          let tmp random length tab
          set x item tmp tab
          set y 16
          set direction "s"
          set spawn-at "n"
          set spawn-n spawn-n + 1
          setxy x y
          set shape "person"
          set color black
        ]
      ]
    ]
    (dir = 1)[
      if (spawn-chance <= spawn-person-w * 4)[
        create-people person-per-tick[
          let tab [1 -2 -7 -10]
          let tmp random length tab
          set y item tmp tab
          set x -16
          set direction "e"
          set spawn-at "w"
          set spawn-w spawn-w + 1
          setxy x y
          set shape "person"
          set color brown
        ]
      ]
    ]
    (dir = 2)[
      if (spawn-chance <= spawn-person-s * 4)[
        create-people person-per-tick[
          let tab [1 -2 7 10]
          let tmp random length tab
          set x item tmp tab
          set y -16
          set direction "n"
          set spawn-at "s"
          set spawn-s spawn-s + 1
          setxy x y
          set shape "person"
          set color yellow
        ]
      ]
    ]
    (dir = 3)[
      if (spawn-chance <= spawn-person-e * 4)[
        create-people person-per-tick[
          let tab [1 -2 7 10]
          let tmp random length tab
          set y item tmp tab
          set x 16
          set direction "w"
          set spawn-at "e"
          set spawn-e spawn-e + 1
          setxy x y
          set shape "person"
          set color red
        ]
      ]
    ]
  )

;  create-people person-per-tick[
;   (ifelse
;      (dir = 0)[
;        let tab [1 -2 -7 -10]
;        let tmp random length tab
;        set x item tmp tab
;        set y 16
;        set direction "s"
;        set spawn-n spawn-n + 1
;      ]
;      (dir = 1)[
;        let tab [1 -2 -7 -10]
;        let tmp random length tab
;        set y item tmp tab
;        set x -16
;        set direction "e"
;        set spawn-w spawn-w + 1
;      ]
;      (dir = 2)[
;        let tab [1 -2 7 10]
;        let tmp random length tab
;        set x item tmp tab
;        set y -16
;        set direction "n"
;        set spawn-s spawn-s + 1
;      ]
;      (dir = 3)[
;        let tab [1 -2 7 10]
;        let tmp random length tab
;        set y item tmp tab
;        set x 16
;        set direction "w"
;        set spawn-e spawn-e + 1
;      ]
;    )

;  create-people person-per-tick [
;    (ifelse (x = 1 or x = -2 or x = -7 or x = -10) and (y = 16)[
;      set direction "s"
;      set spawn-n spawn-n + 1
;      ]
;      (x = -16) and (y = 1 or y = -2 or y = -7 or y = -10)[
;       set direction "e"
;        set spawn-w spawn-w + 1
;      ]
;      (x = 1 or x = -2 or x = 7 or x = 10) and (y = -16)[
;        set direction "n"
;        set spawn-s spawn-s + 1
;      ]
;      (x = 16) and (y = 1 or y = -2 or y = 7 or y = 10)[
;        set direction "w"
;        set spawn-e spawn-e + 1
;      ]
;    )

;    setxy x y
;    set shape "person"
;    set color red
;  ]
end

to move-person
  let newx 0
  let newy 0

  ;;if meet cross pedestraints
  (ifelse
    (direction = "n" or direction = "s")[
      let wx xcor - 1
      let ex xcor + 1
      (ifelse
        ([pcolor] of patch wx ycor = 8)
        [
          let change-direction random 2
          if(change-direction = 0)[
            set direction "w"
          ]
        ]
        ([pcolor] of patch ex ycor = 8)[
          let change-direction random 2
          if(change-direction = 0)[
            set direction "e"
          ]
        ]
      )
    ]
    (direction = "w" or direction = "e")[
      let ny ycor + 1
      let sy ycor - 1
      (ifelse
        ([pcolor] of patch xcor ny = 8)[
          let change-direction random 2
          if(change-direction = 0)[
            set direction "n"
          ]
        ]
        ([pcolor] of patch xcor sy = 8)[
          let change-direction random 2
          if(change-direction = 0)[
            set direction "s"
          ]
        ]
      )
    ]
  )

  ifelse (wait-for-green self = false)[
    set awaits-green false
  ;;if at the end of the way then it changes it's direction
  (ifelse
    (direction = "n")[
      set newy ycor + 1
      ;move-to patch xcor newy
      if (not member? [pcolor] of patch xcor newy [7 8])[
          let wx xcor - 1
          let ex xcor + 1
          let tmp_w 0
          let tmp_e 0
          (ifelse
            ([pcolor] of patch wx ycor = 7)[
              ;set direction "w"
              set tmp_w tmp_w + 1
          ]
            ([pcolor] of patch ex ycor = 7)[
              ;set direction "e"
              set tmp_e tmp_e + 1
            ]
          )
          (ifelse
            (tmp_e + tmp_w = 2)[
              let choose-direction random 2
              (ifelse (choose-direction = 0)[
                set direction  "w"
              ][
                set direction  "e"
              ])
            ]
            (tmp_e = 1)[
              set direction "e"
            ]
            (tmp_w = 1)[
              set direction "w"
            ]
          )

        ]
      ]
      (direction = "w")[
        set newx xcor - 1
        ;move-to patch newx ycor
        if (not member? [pcolor] of patch newx ycor [7 8])[
          let ny ycor + 1
          let sy ycor - 1
          let tmp_n 0
          let tmp_s 0
          (ifelse
            ([pcolor] of patch xcor ny = 7)[
              ;set direction "n"
              set tmp_n tmp_n + 1
            ]
            ([pcolor] of patch xcor sy = 7)[
              ;set direction "s"
              set tmp_s tmp_s + 1
            ]
          )
          (ifelse
            (tmp_n + tmp_s = 2)[
              let choose-direction random 2
              (ifelse (choose-direction = 0)[
                set direction  "n"
              ][
                set direction  "s"
              ])
            ]
            (tmp_n = 1)[
             set direction "n"
            ]
            (tmp_s = 1)[
              set direction "s"
            ]
          )

        ]
      ]
      (direction = "e")[
        set newx xcor + 1
        ;move-to patch newx ycor
        if (not member? [pcolor] of patch newx ycor [7 8])[
          let ny ycor + 1
          let sy ycor - 1
          let tmp_n 0
          let tmp_s 0
          (ifelse
            ([pcolor] of patch xcor ny = 7)[
;              set direction "n"
              set tmp_n tmp_n + 1
            ]
            ([pcolor] of patch xcor sy = 7)[
;              set direction "s"
              set tmp_s tmp_s + 1
            ]
          )
          (ifelse
            (tmp_n + tmp_s = 2)[
              let choose-direction random 2
              (ifelse (choose-direction = 0)[
                set direction  "n"
              ][
                set direction  "s"
              ])
            ]
            (tmp_n = 1)[
             set direction "n"
            ]
            (tmp_s = 1)[
              set direction "s"
            ]
          )

        ]
      ]
      (direction = "s")[
        set newy ycor - 1
        ;move-to patch xcor newy
        if (not member? [pcolor] of patch xcor newy [7 8])[
          let wx xcor - 1
          let ex xcor + 1
          let tmp_w 0
          let tmp_e 0
          (ifelse
            ([pcolor] of patch wx ycor = 7)[
              ;set direction "w"
              set tmp_w tmp_w + 1
            ]
            ([pcolor] of patch ex ycor = 7)[
              ;set direction "e"
              set tmp_e tmp_e + 1
            ]
          )
          (ifelse
            (tmp_e + tmp_w = 2)[
              let choose-direction random 2
              (ifelse (choose-direction = 0)[
                set direction  "w"
              ][
                set direction  "e"
              ])
            ]
            (tmp_e = 1)[
              set direction "e"
            ]
            (tmp_w = 1)[
              set direction "w"
            ]
          )
        ]
      ]
    )

    ;;moves to specific direction
    (ifelse
      direction = "n"[
        set newy ycor + 1
        move-to patch xcor newy
      ]
      direction = "w"[
        set newx xcor - 1
        move-to patch newx ycor
      ]
      direction = "e"[
        set newx xcor + 1
        move-to patch newx ycor
      ]
      direction = "s"[
        set newy ycor - 1
        move-to patch xcor newy
      ]
    )

    ;dies at the end of map
    ;  if (xcor = 16 or xcor = -16) or (ycor = 16 or ycor = -16)[
    ;   die
    ;  ]
    (ifelse
      (xcor = 16)[
        set dies-e dies-e + 1
        set dies-at "e"
        die
      ]
      (xcor = -16)[
        set dies-w dies-w + 1
        set dies-at "w"
        die
      ]
      (ycor = 16)[
        set dies-n dies-n + 1
        set dies-at "n"
        die
      ]
      (ycor = -16)[
        set dies-s dies-s + 1
        set dies-at "s"
        die
      ]
    )
  ]
  [
    set awaits-green true
  ]
end

;;check if person wait for green light
to-report wait-for-green [cars-agent]
  let newx 0
  let newy 0
  let _wait false
;          print("chodnik: ")
;        print([pcolor] of patch xcor ycor)
  ;;if at the end of the way then it changes it's direction
  (ifelse
    (direction = "n")[
      set newy ycor + 1
      ;move-to patch xcor newy
      if ([pcolor] of patch xcor newy = 8 and [pcolor] of patch xcor ycor = 7)[

;        print("pasy: ")
;        print([pcolor] of patch xcor newy)
;        print("chodnik: ")
;        print([pcolor] of patch xcor ycor)
        set _wait true
      ]
    ]
    (direction = "w")[
      set newx xcor - 1
      ;move-to patch newx ycor
      if ([pcolor] of patch newx ycor = 8 and [pcolor] of patch xcor ycor = 7)[
;                print("pasy: ")
;        print([pcolor] of patch newx ycor)
;        print("chodnik: ")
;        print([pcolor] of patch xcor ycor)
        set _wait true
      ]
    ]
    (direction = "e")[
      set newx xcor + 1
      ;move-to patch newx ycor
      if ([pcolor] of patch newx ycor = 8 and [pcolor] of patch xcor ycor = 7)[
;                print("pasy: ")
;        print([pcolor] of patch newx ycor)
;        print("chodnik: ")
;        print([pcolor] of patch xcor ycor)
        set _wait true
      ]
    ]
    (direction = "s")[
      set newy ycor - 1
      ;move-to patch xcor newy
      if ([pcolor] of patch xcor newy = 8 and [pcolor] of patch xcor ycor = 7)[
;                print("pasy: ")
;        print([pcolor] of patch xcor newy)
;        print("chodnik: ")
;        print([pcolor] of patch xcor ycor)
        set _wait true
      ]
    ]
  )

  (ifelse
    (_wait = true)[
      let green-signals patches with [pcolor = green]
      let nearby-green-signals green-signals in-radius 2.5
;      print("green signals")
;      print( nearby-green-signals)
;      print(any? nearby-green-signals)
      report not any? nearby-green-signals
    ]
    [
      report false
    ]
  )

end

to change-signals
  ;;CROSS SIGNAL
  ;print("change0signals")
  (ifelse (automatic-signals = true)[
    auto-signals
    ]
    [
     manual-signals
    ]
  )
end

to auto-signals
  let color-n red
  let color-s red
  let color-e red
  let color-w red

  ;;internal lights
  (ifelse
    (internal-signals-mode = "alternately")[
      ;print(show-horizontal-signals)
      (ifelse
        (show-horizontal-signals = true)[
          ;print(2222222222)
          set color-e green
          set color-w green
          set show-horizontal-signals false
        ]
        [
          ;print(1111111111)
          set color-n green
          set color-s green
          set show-horizontal-signals true
        ]
      )
    ]
    (internal-signals-mode = "clockwise")[

      (ifelse
        (clockwise-signals = 0)
        [
          set color-n green
        ]
        (clockwise-signals = 1)
        [
         set color-e green
        ]
        (clockwise-signals = 2)
        [
         set color-s green
        ]
        (clockwise-signals = 3)
        [
         set color-w green
        ]
      )

      (ifelse
        (clockwise-signals = 3)
        [
         set clockwise-signals 0
        ]
        [
         set clockwise-signals clockwise-signals + 1
        ]
      )
    ]
    (internal-signals-mode = "counterclockwise")[
      (ifelse
        (clockwise-signals = 0)
        [
          set color-n green
        ]
        (clockwise-signals = 1)
        [
         set color-w green
        ]
        (clockwise-signals = 2)
        [
         set color-s green
        ]
        (clockwise-signals = 3)
        [
         set color-e green
        ]
      )

      (ifelse
        (clockwise-signals = 3)
        [
         set clockwise-signals 0
        ]
        [
         set clockwise-signals clockwise-signals + 1
        ]
      )
    ]
  )

  ;;changing inner signals
  ask patch -4 -1[
    set pcolor color-w
  ]

  ask patch 0 -4[
    set pcolor color-s
  ]

  ask patch 3 0[
    set pcolor color-e
  ]

  ask patch -1 3[
    set pcolor color-n
  ]


  set color-n red
  set color-s red
  set color-e red
  set color-w red

  ;;outer lights
  (ifelse
    (outer-signals-mode = "alternately")[
      (ifelse
        (show-outerhorizontal-signals = true)
        [
      ;;clockwise-outer-signals
          set color-e green
          set color-w green
          set show-outerhorizontal-signals false
        ]
        [
          set color-n green
          set color-s green
          set show-outerhorizontal-signals true
        ]
      )
    ]
    (outer-signals-mode = "clockwise")[
      (ifelse
        (clockwise-outer-signals = 0)
        [
          set color-n green
        ]
        (clockwise-outer-signals = 1)
        [
         set color-e green
        ]
        (clockwise-outer-signals = 2)
        [
         set color-s green
        ]
        (clockwise-outer-signals = 3)
        [
         set color-w green
        ]
      )

      (ifelse
        (clockwise-outer-signals = 3)
        [
         set clockwise-outer-signals 0
        ]
        [
         set clockwise-outer-signals clockwise-outer-signals + 1
        ]
      )
    ]
    (outer-signals-mode = "counterclockwise")[
      (ifelse
        (clockwise-outer-signals = 0)
        [
          set color-n green
        ]
        (clockwise-outer-signals = 1)
        [
         set color-w green
        ]
        (clockwise-outer-signals = 2)
        [
         set color-s green
        ]
        (clockwise-outer-signals = 3)
        [
         set color-e green
        ]
      )

      (ifelse
        (clockwise-outer-signals = 3)
        [
         set clockwise-outer-signals 0
        ]
        [
         set clockwise-outer-signals clockwise-outer-signals + 1
        ]
      )
    ]
  )


  ask patch -9 3[
    set pcolor color-w
  ]

  ask patch 3 9[
    set pcolor color-n
  ]

  ask patch -4 -9[
    set pcolor color-s
  ]

  ask patch 9 -4[
    set pcolor color-e
  ]
end

to manual-signals
  let signal-n red
  let signal-s red
  let signal-w red
  let signal-e red

  let o-signal-n red
  let o-signal-s red
  let o-signal-w red
  let o-signal-e red

  if (cross-signal-n = true)[
    set signal-n green
  ]
  if (cross-signal-s = true)[
    set signal-s green
  ]
  if (cross-signal-w = true)[
    set signal-w green
  ]
  if (cross-signal-e = true)[
    set signal-e green
  ]
  if (outer-signal-n = true)[
    set o-signal-n green
  ]
  if (outer-signal-s = true)[
    set o-signal-s green
  ]
  if (outer-signal-w = true)[
    set o-signal-w green
  ]
  if (outer-signal-e = true)[
    set o-signal-e green
  ]

  ask patch -4 -1[
    set pcolor signal-w
  ]

  ask patch 0 -4[
    set pcolor signal-s
  ]

  ask patch 3 0[
    set pcolor signal-e
  ]

  ask patch -1 3[
    set pcolor signal-n
  ]

  ask patch -9 3[
    set pcolor o-signal-w
  ]

  ask patch 3 9[
    set pcolor o-signal-n
  ]

  ask patch -4 -9[
    set pcolor o-signal-s
  ]

  ask patch 9 -4[
    set pcolor o-signal-e
  ]

end
  ;;OTHERS
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
15
27
82
60
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
105
29
168
62
start
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
49
82
136
115
one step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1535
13
1881
263
People
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count people"

SLIDER
12
140
184
173
person-per-tick
person-per-tick
1
10
3.0
1
1
NIL
HORIZONTAL

PLOT
662
326
1070
664
Destination Summary
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"north" 1.0 0 -2674135 true "" "plot dies-n"
"south" 1.0 0 -13345367 true "" "plot dies-s"
"west" 1.0 0 -1184463 true "" "plot dies-w"
"east" 1.0 0 -6459832 true "" "plot dies-e"

PLOT
1314
10
1514
160
Spawn West
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot spawn-w"

PLOT
1315
172
1515
322
Spawn East
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot spawn-e"

PLOT
1107
325
1516
664
Spawn Summary
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"north" 1.0 0 -8630108 true "" "plot spawn-n"
"south" 1.0 0 -1184463 true "" "plot spawn-s"
"east" 1.0 0 -2674135 true "" "plot spawn-e"
"west" 1.0 0 -955883 true "" "plot spawn-w"

MONITOR
663
676
756
721
NIL
count people
17
1
11

SLIDER
12
175
184
208
spawn-person-n
spawn-person-n
0
1
0.25
0.25
1
NIL
HORIZONTAL

SLIDER
13
281
185
314
spawn-person-s
spawn-person-s
0
1
1.0
0.25
1
NIL
HORIZONTAL

SLIDER
12
211
184
244
spawn-person-w
spawn-person-w
0
1
1.0
0.25
1
NIL
HORIZONTAL

SLIDER
12
246
184
279
spawn-person-e
spawn-person-e
0
1
1.0
0.25
1
NIL
HORIZONTAL

PLOT
1106
171
1306
321
Spawn South
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot spawn-s"

PLOT
1105
10
1305
160
Spawn North
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot spawn-n"

PLOT
660
10
860
160
Destination North
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot dies-n"

PLOT
661
170
861
320
Destination South
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot dies-s"

PLOT
870
171
1070
321
Destination East
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot dies-e"

PLOT
870
10
1070
160
Destination West
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot dies-w"

CHOOSER
17
329
182
374
internal-signals-mode
internal-signals-mode
"alternately" "clockwise" "counterclockwise"
2

SWITCH
294
684
465
717
automatic-signals
automatic-signals
1
1
-1000

SWITCH
84
470
231
503
cross-signal-n
cross-signal-n
0
1
-1000

SWITCH
87
552
233
585
cross-signal-s
cross-signal-s
0
1
-1000

SWITCH
170
509
317
542
cross-signal-e
cross-signal-e
1
1
-1000

SWITCH
13
510
162
543
cross-signal-w
cross-signal-w
1
1
-1000

SWITCH
414
465
561
498
outer-signal-n
outer-signal-n
0
1
-1000

SWITCH
412
554
558
587
outer-signal-s
outer-signal-s
0
1
-1000

SWITCH
497
509
644
542
outer-signal-e
outer-signal-e
1
1
-1000

SWITCH
335
509
484
542
outer-signal-w
outer-signal-w
0
1
-1000

CHOOSER
18
375
177
420
outer-signals-mode
outer-signals-mode
"alternately" "clockwise" "counterclockwise"
0

PLOT
1534
282
1971
665
wait-move
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"move" 1.0 0 -13840069 true "" "plot count people with [awaits-green = false]"
"wait" 1.0 0 -2674135 true "" "plot count people with [awaits-green = true]"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
