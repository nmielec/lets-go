#import "@preview/cetz:0.4.1"

#cetz.canvas({
  import cetz.draw: *
  // Your drawing code goes here
})

#lorem(10)

///
///
/// - move (str):
/// ->
#let input-position-to-coords(move) = {
  let m = move.match(regex("([ABCDEFGHIJKLMNOPQRSTabcdefghijklmnopqrst])(\d{1,2})"))
  if m != none {
    let A_UNICODE = 65
    let ZERO_UNICODE = 50
    return (
      row: m.captures.at(0).codepoints().at(0).to-unicode() - A_UNICODE,
      col: int(m.captures.at(1)) - 1,
    )
  }

  let m = move.match(regex("([abcdefghijklmnopqrst])([abcdefghijklmnopqrst])"))
  if m != none {
    let a_unicode = 97
    return (
      row: m.captures.at(0).to-unicode() - a_unicode,
      col: m.captures.at(1).to-unicode() - a_unicode,
    )
  }

  return none
}

#let go-board(stones: (), size: 13, marks: (), padding: 0mm) = {
  let spacing = 7mm


  block(
    fill: orange.lighten(70%),
    width: size * spacing + 2 * padding,
    height: size * spacing + 2 * padding,
    {
      for p in range(size) {
        place(dy: spacing * p + spacing / 2 + padding, dx: spacing / 2 + padding, line(length: (size - 1) * spacing))
      }

      for p in range(size) {
        place(dx: spacing * p + spacing / 2 + padding, dy: spacing / 2 + padding, line(
          angle: 90deg,
          length: (size - 1) * spacing,
        ))
      }

      let draw-stone() = {
        let r = spacing / 2.5
        place(dx: -r, dy: -r, circle(
          radius: r,
          fill: gradient.radial(center: (40%, 40%), white, white.darken(20%)),
          // stroke: 0.3pt,
        ))
        // place(dx: -r, dy: -r, circle(radius: r))
      }

      let mark-radius = 1mm
      for mark in marks {
        place(
          dx: padding + (mark.at(0) + 0.5) * spacing - mark-radius,
          dy: padding + (mark.at(1) + 0.5) * spacing - mark-radius,
          circle(
            radius: mark-radius,
            fill: black,
            stroke: none,
          ),
        )
      }

      for stone in stones {
        let coords = input-position-to-coords(stone)
        place(dx: padding + (coords.col + 0.5) * spacing, dy: padding + (coords.row + 0.5) * spacing, draw-stone())
      }
    },
  )
}

#let full-go-board = go-board.with(
  marks: ((3, 3), (3, 9), (3, 15), (9, 3), (9, 9), (9, 15), (15, 3), (15, 9), (15, 15)),
  size: 19,
)

#let go-board-19 = full-go-board
#let go-board-13 = go-board.with(
  size: 13,
  marks: ((3, 3), (9, 3), (3, 9), (9, 9), (6, 6)),
)
#let go-board-9 = go-board.with(
  size: 9,
  marks: ((2, 2), (6, 2), (2, 6), (6, 6), (4, 4)),
)

#go-board-9(
  stones: (
    "A1",
    "A2",
    "cd",
  ),
  padding: 1mm,
)
#lorem(20)
