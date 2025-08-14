#lorem(10)

///
///
/// - position (str):
/// ->
#let input-position-to-coords(position) = {
  let m = position.match(regex("([ABCDEFGHIJKLMNOPQRSTabcdefghijklmnopqrst])(\d{1,2})"))
  if m != none {
    let A_UNICODE = 65
    let ZERO_UNICODE = 50
    return (
      row: m.captures.at(0).codepoints().at(0).to-unicode() - A_UNICODE,
      col: int(m.captures.at(1)) - 1,
    )
  }

  let m = position.match(regex("([abcdefghijklmnopqrst])([abcdefghijklmnopqrst])"))
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
  let background-color = orange.lighten(70%)

  let ratio-line-board-len = (100% - 2 * padding) * (size - 1) / size
  let edge-padding = padding + 0.5 / (size - 1) * ratio-line-board-len

  let mark-radius = 2%
  let stone-diameter = 0.75 / size * 100%

  let draw-stone(highlight-color: none, shadow-color: none, diameter) = {
    move(
      dx: -diameter / 2,
      dy: -diameter / 2,
      circle(
        width: diameter,
        fill: gradient.radial(center: (40%, 40%), highlight-color, shadow-color),
      ),
    )
  }
  let draw-black-stone = draw-stone.with(highlight-color: luma(130), shadow-color: luma(40))
  let draw-white-stone = draw-stone.with(highlight-color: luma(100%), shadow-color: luma(70%))


  square(
    fill: background-color,
    inset: 0%,
    outset: 0%,
    width: 100%,
    {
      for p in range(size) {
        place(
          dy: edge-padding + p / (size - 1) * ratio-line-board-len,
          dx: edge-padding,
          line(length: ratio-line-board-len),
        )
      }

      for p in range(size) {
        place(
          dx: edge-padding + p / (size - 1) * ratio-line-board-len,
          dy: edge-padding,
          line(angle: 90deg, length: ratio-line-board-len),
        )
      }

      for mark in marks {
        place(
          dx: edge-padding + (mark.at(0)) * ratio-line-board-len / (size - 1) - mark-radius / 2,
          dy: edge-padding + (mark.at(1)) * ratio-line-board-len / (size - 1) - mark-radius / 2,
          circle(
            width: mark-radius,
            fill: black,
            stroke: none,
          ),
        )
      }

      for (i, stone) in stones.enumerate() {
        let coords = input-position-to-coords(stone)
        place(
          dx: edge-padding + (coords.col) * ratio-line-board-len / (size - 1),
          dy: edge-padding + (coords.row) * ratio-line-board-len / (size - 1),
          if calc.even(i) {
            draw-white-stone(stone-diameter)
          } else { draw-black-stone(stone-diameter) },
        )
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

#block(width: 100%, go-board-19(stones: ("ab", "ac", "ef"), padding: 1mm)),

#lorem(20)
