#import "naju-bericht.typ": bericht, kapitel

#show: bericht.with(
  titel: "Rechenschaftsbericht",
  untertitel: "Ein Jahr Naturschutz, Bildung und Engagement",
  zeitraum: "2025/26",
  organisation: "NAJU Bayern",
  titelbild: image("bilder/titel.jpg"),
  // logo: image("bilder/logo.png"),
)

#kapitel("Bericht des Vorstands", bild: image("bilder/kapitel-vorstand.jpg"))

#lorem(90)

== Rückblick auf das Jahr

#lorem(120)

#lorem(80)

== Schwerpunkte

- #lorem(12)
- #lorem(15)
- #lorem(10)

#lorem(150)

#figure(
  image("bilder/kapitel-aktionen.jpg", width: 100%),
  caption: [Bildunterschrift – z. B. Pflanzaktion im Frühjahr],
)

#lorem(100)

#kapitel("Arbeitskreise", bild: image("bilder/kapitel-arbeitskreise.jpg"))

== AK Amphibien

#lorem(110)

== AK Umweltbildung

#lorem(130)

#kapitel("Aktionen & Veranstaltungen", bild: image("bilder/kapitel-aktionen.jpg"))

#lorem(160)

#kapitel("Finanzen", bild: image("bilder/kapitel-finanzen.jpg"))

#lorem(40)

#table(
  columns: (1fr, auto),
  align: (left, right),
  [Posten], [Betrag],
  [Mitgliedsbeiträge], [12.400,00 €],
  [Zuschüsse], [8.250,00 €],
  [Spenden], [3.120,50 €],
  [*Summe Einnahmen*], [*23.770,50 €*],
)

// Kapitel ohne Banner, aber mit Bild im Inhaltsverzeichnis:
#kapitel("Ausblick", bild: image("bilder/titel.jpg"), banner: false)

#lorem(80)
