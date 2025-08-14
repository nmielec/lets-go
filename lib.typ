///
///
/// - position (str):
/// ->
#let input-position-to-coords(position) = {
  if type(position) == array {
    return (
      row: position.at(0),
      col: position.at(1),
    )
  }

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

#let draw-stone(highlight-color: none, shadow-color: none) = {
  move(
    dx: -50%,
    dy: -50%,
    circle(
      width: 100%,
      fill: gradient.radial(center: (40%, 40%), highlight-color, shadow-color),
    ),
  )
}
#let black-stone = draw-stone(highlight-color: luma(130), shadow-color: luma(40))
#let white-stone = draw-stone(highlight-color: luma(100%), shadow-color: luma(70%))

#let go-board(
  stones: (),
  size: 13,
  marks: (),
  padding: 0mm,
  board-fill: orange.lighten(70%),
  mark-radius: 2%,
  stone-diameter-ratio: 0.75,
  black-stone: black-stone,
  white-stone: white-stone,
  open-edges: "",
  open-edges-added-length: 4%,
) = {
  let ratio-line-board-len = (100% - 2 * padding) * (size - 1) / size
  let edge-padding = padding + 0.5 / (size - 1) * ratio-line-board-len
  let stone-diameter = stone-diameter-ratio / size * 100%

  black-stone = scale(stone-diameter-ratio / size * 100%, origin: top + left, black-stone)
  white-stone = scale(stone-diameter-ratio / size * 100%, origin: top + left, white-stone)

  let open-edges-paddings = (
    "n": 0%,
    "e": 0%,
    "s": 0%,
    "w": 0%,
  )

  for dir in open-edges-paddings.keys() {
    if open-edges.contains(dir) {
      open-edges-paddings.insert(dir, open-edges-added-length)
    }
  }

  square(
    fill: board-fill,
    stroke: none,
    inset: 0%,
    outset: 0%,
    width: 100%,
    {
      for p in range(size) {
        place(
          dy: edge-padding + p / (size - 1) * ratio-line-board-len,
          dx: edge-padding - open-edges-paddings.at("w"),
          line(length: ratio-line-board-len + open-edges-paddings.at("e") + open-edges-paddings.at("w")),
        )
      }

      for p in range(size) {
        place(
          dx: edge-padding + p / (size - 1) * ratio-line-board-len,
          dy: edge-padding - open-edges-paddings.at("n"),
          line(angle: 90deg, length: ratio-line-board-len + open-edges-paddings.at("n") + open-edges-paddings.at("s")),
        )
      }

      for mark in marks {
        let coords = input-position-to-coords(mark)
        place(
          dx: edge-padding + (coords.col) * ratio-line-board-len / (size - 1) - mark-radius / 2,
          dy: edge-padding + (coords.row) * ratio-line-board-len / (size - 1) - mark-radius / 2,
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
            black-stone
          } else { white-stone },
        )
      }
    },
  )
}

#let go-board-19 = go-board.with(
  marks: ((3, 3), (3, 9), (3, 15), (9, 3), (9, 9), (9, 15), (15, 3), (15, 9), (15, 15)),
  size: 19,
)
#let go-board-13 = go-board.with(
  size: 13,
  marks: ((3, 3), (9, 3), (3, 9), (9, 9), (6, 6)),
)
#let go-board-9 = go-board.with(
  size: 9,
  marks: ((2, 2), (6, 2), (2, 6), (6, 6), (4, 4)),
)

#let stones = ("ab", "ac", "ef")

#box(stroke: black, width: 5cm, go-board-9(stones: stones))
#box(stroke: black, width: 5cm, go-board(
  size: 5,
  // Stones stay positioned from the top left corner
  stones: ("ac", "bb"),
  marks: ("db",),
  mark-radius: 5%,
  open-edges: "sw",
  open-edges-added-length: 7%,
  padding: 2mm,
  board-fill: luma(90%),
  black-stone: move(dx: -50%, dy: -50%, circle(
    width: 100%,
    fill: black,
    stroke: white + 0.2pt,
  )),
  white-stone: move(dx: -50%, dy: -50%, circle(
    width: 100%,
    fill: white,
    stroke: black + 0.2pt,
  )),
  stone-diameter-ratio: 1,
))

