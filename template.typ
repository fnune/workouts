#let slug(name) = {
  lower(name).replace(regex("[^a-z0-9]+"), "-").trim("-")
}

#let warmup(items) = {
  block(
    width: 100%,
    inset: (x: 0pt, y: 0pt),
    above: 4pt,
    below: 10pt,
  )[
    #text(size: 9pt, fill: luma(50%))[Stretch: #items]
  ]
}

#let exercise(name, sets, cue) = {
  let img-path = "images/" + slug(name) + ".jpg"
  block(
    width: 100%,
    inset: (x: 0pt, y: 5pt),
    stroke: (top: 0.6pt + luma(80%)),
    breakable: false,
  )[
    #grid(
      columns: (100pt, 1fr),
      column-gutter: 12pt,
      align: (center + horizon, left + horizon),
      box(
        width: 100pt,
        height: 72pt,
        image(img-path, width: 100%, height: 100%, fit: "contain"),
      ),
      stack(
        spacing: 5pt,
        text(size: 13pt, weight: "semibold")[#name],
        text(size: 10.5pt, fill: rgb("#b14a00"))[#sets],
        text(size: 10pt, fill: luma(20%))[#cue],
      ),
    )
  ]
}

#let workout(title: none, equipment: none, body) = {
  set page(
    paper: "a4",
    margin: (x: 12mm, y: 10mm),
    footer: align(center)[
      #text(size: 6.5pt, fill: luma(65%))[
        images: #link("https://github.com/yuhonas/free-exercise-db")[yuhonas/free-exercise-db] (public domain) · built with #link("https://typst.app")[typst], #link("https://imagemagick.org")[imagemagick], #link("https://nixos.org")[nix]
      ]
    ],
  )
  set text(font: ("Inter", "Liberation Sans", "DejaVu Sans"), size: 11pt)
  set par(leading: 0.7em)

  text(size: 19pt, weight: "semibold")[#title]
  if equipment != none {
    linebreak()
    text(size: 9.5pt, fill: luma(40%))[#equipment]
  }

  body
}
