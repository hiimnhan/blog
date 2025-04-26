
// Some parts of this template are copied verbatim on the clean-math-paper template.
// https://github.com/JoshuaLampert/clean-math-paper/tree/main
#import "@preview/great-theorems:0.1.2": (
  great-theorems-init,
  proofblock,
  mathblock,
)
#import "@preview/rich-counters:0.2.2": rich-counter
#import "@preview/i-figured:0.2.4": reset-counters, show-equation
#let custom_template(title: "", keywords: (), body) = {
  let date = datetime.today().display("[month repr:long] [day], [year]")
  let mathpar(content) = {
    align(center)[
      #block(width: 90%)[
        #align(left)[#content]
      ]
    ]
  }

  let link-color = rgb("#0000ff")
  let heading-color = rgb("#000000")

  set page(
    margin: (left: 25mm, right: 25mm, top: 25mm, bottom: 30mm),
    numbering: "1",
    number-align: center,
  )
  set text(font: "New Computer Modern", lang: "en")
  show link: set text(fill: link-color)
  show ref: set text(fill: link-color)
  show figure.where(kind: table): set figure.caption(position: top)

  // Heading settings.
  set heading(numbering: "1.1")
  show heading.where(level: 1): set text(size: 14pt, fill: heading-color)
  show heading.where(level: 2): set text(size: 12pt, fill: heading-color)

  // Equation settings.
  // Using i-figured:
  show heading: reset-counters
  show math.equation: show-equation.with(prefix: "eq:", only-labeled: true)

  // Using headcount:
  // show heading: reset-counter(counter(math.equation))
  // set math.equation(numbering: dependent-numbering("(1.1)"))
  set math.equation(supplement: none)
  show math.equation: box // no line breaks in inline math
  set enum(numbering: "(i)")
  set outline(indent: 2em) // indent: auto does not work well with appendices
  show: great-theorems-init
  show figure.caption: emph
  set footnote(numbering: "*")

  let item-counter = counter("item-counter")

  show enum: it => {
    if it.start != 0 { return it }
    let args = it.fields()
    let items = args.remove("children")
    context enum(..args, start: item-counter.get().first() + 1, ..items)
    item-counter.update(i => i + it.children.len())
  }

  set bibliography(style: "chicago-author-date")
  body
}

#let proof = proofblock(suffix: $qed$)
// counter for mathblocks
#let theoremcounter = rich-counter(
  identifier: "mathblocks",
  inherited_levels: 1,
)

#let my-mathblock = mathblock.with(
  counter: theoremcounter,
  breakable: false,
  titlix: title => [(#title):],
  // suffix: [#h(1fr) $triangle.r$],
)

// theorem etc. settings
#let theorem = my-mathblock(
  blocktitle: "Theorem",
  bodyfmt: text.with(style: "italic"),
)

#let proposition = my-mathblock(
  blocktitle: "Proposition",
  bodyfmt: text.with(style: "italic"),
)

#let corollary = my-mathblock(
  blocktitle: "Corollary",
  bodyfmt: text.with(style: "italic"),
)

#let lemma = my-mathblock(
  blocktitle: "Lemma",
  bodyfmt: text.with(style: "italic"),
)

#let definition = my-mathblock(
  blocktitle: "Definition",
  bodyfmt: text.with(style: "italic"),
)

#let remark = my-mathblock(blocktitle: [_Remark_])

#let example = my-mathblock(blocktitle: [_Example_])

#let question = my-mathblock(blocktitle: [_Question_])
