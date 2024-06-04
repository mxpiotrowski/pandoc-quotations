# pandoc-quotations

`quotations.lua` is a Pandoc Lua filter that implements a number of common operations with quotations.  It works using spans with certain classes (the class names are provisional):

- `.ellipsis`: replace the contents of the span with an ellipsis.
- `.elision`: hide the contents of the span.
- `.cap`: capitalize the first word of the span.
- `.lc`: lowercase the first word of the span.
- `.sic` append [_sic_] after the span.
- `.add`: enclose the contents of the span in brackets.
- `.corr`: replace the contents of the span with the value of the attribute `repl`.

Except for `.elision`, the changes are marked with brackets.

The filter is not intended for critical editions, but its main purpose is rather to allow you to adapt a quotation to the context of your paper, document the changes, and avoid changing the actual quotation.  In particular, you can have the full cited passage in your source text, so you can easily refer to it, even if only parts of it are quoted in your paper.

For example, take the following passage (from Busa, Roberto A. 2004.  “Foreword: Perspectives on the Digital Humanities.”  In A Companion to Digital Humanities, edited by Susan Schreibman, Ray Siemens, and John Unsworth, xvi–xxi.  Oxford: Blackwell. <https://doi.org/10.1002/9780470999875.fmatter>):

> Humanities computing is precisely the automation of every possible analysis of human expression (therefore, it is exquisitely a “humanistic” activity), in the widest sense of the word, from music to the theater, from design and painting to phonetics, but whose nucleus remains the discourse of written texts.

We may want to quote it like this:

> This was already suggested by Busa when he stated that “[h]umanities computing is precisely the automation of every possible analysis of human expression […], in the widest sense of the word, from music to the theater, from design and painting to phonetics” …

With `quotations.lua` you’d to mark it up as follows:

```
This was already suggested by Busa when he wrote that
“[Humanities]{.lc} computing is precisely the automation
of every possible analysis of human expression [(therefore,
it is exquisitely a “humanistic” activity)]{.ellipsis}, in
the widest sense of the word, from music to the theater,
from design and painting to phonetics[, but whose nucleus
remains the discourse of written texts.]{.elision}” …
```

This allows you to keep the original context and make adjustments to the quoted part as you edit your manuscript.

See `test.md` for more examples (provided that you have LaTeX or groff installed you can render it to PDF with `make test-latex.pdf` or `make test-ms.pdf`; you can convert it to HTML with `make test.html`).

-------------------------------------------------------------------------------

© 2024 by Michael Piotrowski <mxp@dynalabs.de>
