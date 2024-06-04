# Ellipsis

Replace the contents of the span with an ellipsis.

| Markdown                                  | Output                                  |
|-------------------------------------------|-----------------------------------------|
| `Lorem [ipsum dolor]{.ellipsis} sit amet` | Lorem [ipsum dolor]{.ellipsis} sit amet |

# Elision

Hide the contents of the span.

| Markdown                                 | Output                                 |
|------------------------------------------|----------------------------------------|
| `Lorem [ipsum dolor]{.elision} sit amet` | Lorem [ipsum dolor]{.elision} sit amet |

# Capitalize

Capitalize the first word of the span.

| Markdown                             | Output                             |
|--------------------------------------|------------------------------------|
| `Lorem [ipsum]{.cap} dolor sit amet` | Lorem [ipsum]{.cap} dolor sit amet |

The span can include markup; it can also contain more than one word, but only the first word is capitalized:
    
| Markdown                                   | Output                                   |
|--------------------------------------------|------------------------------------------|
| `Lorem [_ipsum_ foo]{.cap} dolor sit amet` | Lorem [_ipsum_ foo]{.cap} dolor sit amet |

# Lowercase

Lowercase the first word of the span.

| Markdown                            | Output                            |
|-------------------------------------|-----------------------------------|
| `[Lorem]{.lc} ipsum dolor sit amet` | [Lorem]{.lc} ipsum dolor sit amet |

The span can include markup; it can also contain more than one word, but only the first word is lowercased:
    
| Markdown                                  | Output                                  |
|-------------------------------------------|-----------------------------------------|
| `[_Lorem Foo_]{.lc} ipsum dolor sit amet` | [_Lorem Foo_]{.lc} ipsum dolor sit amet |
    
# Sic

Append [_sic_] to the contents of the span.

| Markdown                               | Output                               |
|----------------------------------------|--------------------------------------|
| `Lorem [itsum _dulor_]{.sic} sit amet` | Lorem [itsum _dulor_]{.sic} sit amet |

# Addition

Enclose the contents of span in brackets.

| Markdown                               | Output                               |
|----------------------------------------|--------------------------------------|
| `Lorem [itsum _dulor_]{.add} sit amet` | Lorem [itsum _dulor_]{.add} sit amet |

# Correction

Replace the contents of span with the value of the attribute `repl`.

| Markdown                                           | Output                                           |
|----------------------------------------------------|--------------------------------------------------|
| `Lorem [itsum _dulor_]{.corr repl=ipsum} sit amet` | Lorem [itsum _dulor_]{.corr repl=ipsum} sit amet |
    
The value of the `repl` attribute is parsed as Markdown, so it’s possible to use inline markup in the replacement text:

| Markdown                                                     | Output                                                     |
|--------------------------------------------------------------|------------------------------------------------------------|
| `Lorem [itsum _dulor_]{.corr repl="ipsum _dolor_"} sit amet` | Lorem [itsum _dulor_]{.corr repl="ipsum _dolor_"} sit amet |

# Notes

The class names are provisional.  The filter currently doesn’t remove the classes it handles; I’m not sure whether it should.

You can combine the following classes of this filter with other classes, “pseudoclasses,” and attributes.  By “pseudoclasses” I mean `.underline`, `.smallcaps`, and `.mark`, which syntactically look like classes, but actually create the own node types in the AST.

For `Lorem [itsum _dulor_]{.<Class> .underline} sit amet` we get:

| Class | Output                                          |
|-------|-------------------------------------------------|
| cap   | Lorem [itsum _dulor_]{.cap .underline} sit amet |
| lc    | Lorem [itsum _dulor_]{.lc .underline} sit amet  |
| sic   | Lorem [itsum _dulor_]{.sic .underline} sit amet |
| add   | Lorem [itsum _dulor_]{.add .underline} sit amet |

`.ellipsis` and `.corr` behave differently, though, because they _replace_ the existing content:

| Class    | Output                                                                |
|----------|-----------------------------------------------------------------------|
| ellipsis | Lorem [itsum _dulor_]{.ellipsis .underline} sit amet                  |
| corr     | Lorem [itsum _dulor_]{.corr repl="ipsum _dolor_" .underline} sit amet |

Intuitively, one may expect that `.underline` should apply to the replacement.  However, `[itsum dulor]{.ellipsis .underline}` and `[[itsum dulor]{.underline}]{.ellipsis}` produce exactly the same parse tree, viz.:

``` json
{
    "t": "Span",
    "c": [ ["", ["ellipsis"], [] ],
           [ { "t": "Underline",
               "c": [ { "t": "Str", "c": "itsum" },
                      { "t": "Space" },
                      { "t": "Str", "c": "dulor" }
                    ]
             }
           ]
         ]
}
```

This means that there is no way to determine the author’s intention; the fact that the underline applies to the whole content of the span is merely accidental.

In contrast, `[itsum dulor]{.ellipsis .foobar}` (with `.foobar` being a “real” class rather than a pseudoclass like `.underline`) results in a different parse tree:

``` json
{
    "t": "Span",
    "c": [ ["", ["ellipsis", "foobar"], []],
           [ { "t": "Str", "c": "itsum" },
             { "t": "Space" },
             {"t": "Str", "c": "dulor"}
           ]
         ]
}
```

Thus, unlike pseudoclasses, “real” classes are attached to the Span and will be preserved.

Since the `repl` attribut of `.corr` is parsed as Markdown, it is possible to specify the desired markup in the replacement.

