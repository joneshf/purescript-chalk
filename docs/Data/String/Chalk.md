## Module Data.String.Chalk

#### `Style`

``` purescript
data Style
  = Bold
  | Dim
  | Hidden
  | Inverse
  | Italic
  | Reset
  | Strikethrough
  | Underline
  | Black
  | Blue
  | Cyan
  | Gray
  | Green
  | Magenta
  | Red
  | White
  | Yellow
  | BgBlack
  | BgBlue
  | BgCyan
  | BgGreen
  | BgMagenta
  | BgRed
  | BgWhite
  | BgYellow
```

##### Instances
``` purescript
instance showStyle :: Show Style
instance arbStyle :: Arbitrary Style
```

#### `styles`

``` purescript
styles :: Array Style
```

All styles excluding `Reset`.

#### `chalk`

``` purescript
chalk :: Style -> String -> String
```

Style a string with the given style. Unlike the JavaScript Chalk, this
will add the styling regardless of whether it is supported by the current
terminal. Note that `chalk` is effectful in that it changes its blue color
depending on whether it is on Windows.

#### `chalk'`

``` purescript
chalk' :: Array Style -> String -> String
```

The same as `chalk` but for multiple styles. In case of conflict
(e.g. multiple colors or a `Reset`), the later style will generally take
precedence, however both styles are added and so it is dependent on the
terminal's rendering.


