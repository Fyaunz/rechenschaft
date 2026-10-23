// ============================================================
//  naju-bericht.typ – Template für Rechenschaftsberichte
//
//  Verwendung:
//    #import "naju-bericht.typ": bericht, kapitel
//    #show: bericht.with(titel: "...", titelbild: image("..."))
//    #kapitel("Titel", bild: image("..."))
// ============================================================

// Bild in einen festen Rahmen einpassen (beschneidet statt zu verzerren)
#let _eingepasst(bild, breite, hoehe, radius: 0pt) = box(
  width: breite,
  height: hoehe,
  radius: radius,
  clip: true,
  {
    set image(width: breite, height: hoehe, fit: "cover")
    bild
  },
)

// ------------------------------------------------------------
//  Kapitel: neue Seite, optional Bildbanner, Überschrift.
//  Das Bild erscheint zusätzlich klein im Inhaltsverzeichnis.
// ------------------------------------------------------------
#let kapitel(titel, bild: none, banner: true) = {
  pagebreak(weak: true)
  if bild != none and banner {
    block(above: 0pt, below: 1.4em, _eingepasst(bild, 100%, 6.5cm, radius: 6pt))
  }
  heading(level: 1, titel)
  [#metadata(bild)<naju-kapitelbild>]
}

// ------------------------------------------------------------
//  Haupt-Template
// ------------------------------------------------------------
#let bericht(
  titel: "Rechenschaftsbericht",
  untertitel: none,
  zeitraum: none, // z. B. "2025/26"
  organisation: "NAJU Bayern",
  titelbild: none, // image("...")
  logo: none, // image("...")
  farbe: rgb("#0069b4"), // Akzentfarbe – auf CD-Farbe anpassen
  schrift: ("Open Sans", "Libertinus Serif"), // Fließtext
  schrift-titel: ("Philosopher", "Libertinus Serif"), // Überschriften & Titel
  inhaltsverzeichnis: true,
  body,
) = {
  set document(title: titel, author: organisation)
  set text(lang: "de", region: "DE", font: schrift, size: 10pt)
  set par(justify: true, leading: 0.72em, spacing: 1.2em)

  // Gibt an, ob eine Seite zum eigentlichen Inhalt gehört
  let im-inhalt() = {
    let start = query(<naju-start>)
    start.len() > 0 and here().page() >= start.first().location().page()
  }
  let ist-kapitelanfang() = query(heading.where(level: 1)).any(h => h.location().page() == here().page())

  set page(
    paper: "a4",
    margin: (top: 2.8cm, bottom: 2.6cm, x: 2.4cm),
    header: context {
      if im-inhalt() and not ist-kapitelanfang() {
        let vorher = query(selector(heading.where(level: 1)).before(here()))
        set text(size: 8.5pt, fill: luma(110))
        grid(
          columns: (1fr, auto),
          [#titel #if zeitraum != none [#zeitraum]],
          if vorher.len() > 0 {
            text(font: schrift-titel, size: 9.5pt, fill: farbe, weight: "bold", vorher.last().body)
          },
        )
        v(-0.4em)
        line(length: 100%, stroke: 0.5pt + luma(200))
      }
    },
    footer: context {
      if im-inhalt() {
        set text(size: 8.5pt, fill: luma(110))
        grid(
          columns: (1fr, auto),
          align: horizon,
          organisation, text(size: 10pt, weight: "bold", fill: farbe, counter(page).display()),
        )
      }
    },
  )

  // ---------- Überschriften ----------
  show heading: set par(justify: false)
  show heading: set text(font: schrift-titel)
  // (Seitenumbruch übernimmt #kapitel, damit das Banner mit auf der Seite steht)
  show heading.where(level: 1): it => {
    block(below: 1.2em, {
      text(size: 30pt, weight: "bold", fill: farbe, it.body)
      v(0.1em)
      line(length: 2.5cm, stroke: 2.5pt + farbe)
    })
  }
  show heading.where(level: 2): it => block(above: 1.8em, below: 0.8em, text(
    size: 15pt,
    weight: "bold",
    fill: farbe,
    it.body,
  ))
  show heading.where(level: 3): it => block(above: 1.4em, below: 0.6em, text(size: 12pt, weight: "bold", it.body))

  // ---------- Kleinkram ----------
  set list(marker: text(fill: farbe, sym.bullet))
  set enum(numbering: n => text(fill: farbe, weight: "bold", str(n) + "."))
  show figure.caption: set text(size: 8.5pt, fill: luma(90))
  set table(
    stroke: (_, y) => if y == 0 { (bottom: 1pt + farbe) } else { (bottom: 0.4pt + luma(220)) },
    fill: (_, y) => if y == 0 { farbe.lighten(88%) },
    inset: (x: 6pt, y: 5pt),
  )
  show table.cell.where(y: 0): set text(weight: "bold")
  show link: set text(fill: farbe)

  // ========== Titelseite ==========
  page(margin: 0pt, header: none, footer: none, fill: farbe, {
    if titelbild != none {
      place(_eingepasst(titelbild, 100%, 100%))
    }
    // Verlauf, damit der Text auf jedem Foto lesbar bleibt
    place(bottom, rect(width: 100%, height: 60%, fill: gradient.linear(
      black.transparentize(100%),
      black.transparentize(30%),
      angle: 90deg,
    )))

    if logo != none {
      place(top + right, dx: -1.6cm, dy: 1.6cm, box(fill: white, inset: 10pt, radius: 6pt, {
        set image(height: 2.2cm)
        logo
      }))
    }

    place(bottom + left, dx: 2.4cm, dy: -2.6cm, block(width: 21cm - 4.8cm, {
      set text(fill: white)
      set par(justify: false, leading: 0.4em)
      if zeitraum != none {
        text(size: 13pt, weight: "bold", tracking: 2pt, upper(zeitraum))
        v(0.5em)
      }
      text(font: schrift-titel, size: 44pt, weight: "bold", titel)
      if untertitel != none {
        v(0.4em)
        text(font: schrift-titel, size: 17pt, untertitel)
      }
      v(1.4em)
      line(length: 3cm, stroke: 3pt + white)
      v(0.6em)
      text(size: 13pt, weight: "semibold", organisation)
    }))
  })

  // ========== Inhaltsverzeichnis ==========
  if inhaltsverzeichnis {
    page(header: none, footer: none, context {
      text(font: schrift-titel, size: 30pt, weight: "bold", fill: farbe, "Inhalt")
      v(0.1em)
      line(length: 2.5cm, stroke: 2.5pt + farbe)
      v(1.6em)

      let bilder = query(<naju-kapitelbild>)
      for h in query(heading.where(level: 1)) {
        let eintrag = bilder.find(m => m.location().page() == h.location().page())
        let bild = if eintrag != none { eintrag.value }
        let seite = counter(page).at(h.location()).first()

        let vorschau = if bild != none {
          _eingepasst(bild, 2cm, 2cm, radius: 5pt)
        } else {
          box(width: 2cm, height: 2cm, radius: 5pt, fill: farbe.lighten(85%))
        }

        link(h.location(), block(width: 100%, inset: (y: 7pt), stroke: (bottom: 0.5pt + luma(225)), grid(
          columns: (2cm, 1fr, auto),
          column-gutter: 1.1em,
          align: horizon,
          vorschau,
          text(font: schrift-titel, size: 15pt, weight: "bold", fill: black, h.body),
          text(font: schrift-titel, size: 15pt, weight: "bold", fill: farbe, str(seite)),
        )))
      }
    })
  }

  // ========== Inhalt ==========
  counter(page).update(1)
  [#metadata(none)<naju-start>]
  body
}
