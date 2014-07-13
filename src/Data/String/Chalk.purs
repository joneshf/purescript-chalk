module Data.String.Chalk
  ( Style(..)
  , chalk
  , chalk'
  , hasColor
  , stripColor
  ) where

  import Debug.Trace

  foreign import localChalk "var localChalk = require('chalk');" :: Unit

             -- | General
  data Style = Bold
             | Dim
             | Hidden
             | Inverse
             | Italic -- (not widely supported)
             | Reset
             | Strikethrough -- (not widely supported)
             | Underline
             -- | Text colors
             | Black
             | Blue
             | Cyan
             | Gray
             | Green
             | Magenta
             | Red
             | White
             | Yellow
             -- | Background colors
             | BgBlack
             | BgBlue
             | BgCyan
             | BgGreen
             | BgMagenta
             | BgRed
             | BgWhite
             | BgYellow

  instance showStyle :: Show Style where
    show BgBlack       = "bgblack"
    show BgBlue        = "bgblue"
    show BgCyan        = "bgcyan"
    show BgGreen       = "bggreen"
    show BgMagenta     = "bgmagenta"
    show BgRed         = "bgred"
    show BgWhite       = "bgwhite"
    show BgYellow      = "bgyellow"
    show Black         = "black"
    show Blue          = "blue"
    show Bold          = "bold"
    show Cyan          = "cyan"
    show Dim           = "dim"
    show Gray          = "gray"
    show Green         = "green"
    show Hidden        = "hidden"
    show Inverse       = "inverse"
    show Italic        = "italic"
    show Magenta       = "magenta"
    show Red           = "red"
    show Reset         = "reset"
    show Strikethrough = "strikethrough"
    show Underline     = "underline"
    show White         = "white"
    show Yellow        = "yellow"

  chalk :: Style -> String -> String
  chalk style string = unsafeChalk [style] string

  chalk' :: [Style] -> String -> String
  chalk' styles string = unsafeChalk styles string

  hasColor :: String -> Boolean
  hasColor string = unsafeCallChalk "hasColor" string

  stripColor :: String -> String
  stripColor string = unsafeCallChalk "stripColor" string

  showStyle_ :: Style -> String
  showStyle_ = show

  foreign import unsafeChalk
    "function unsafeChalk(styles) {\
    \  return function(string) {\
    \    return styles.reduce(function(chalk, style) {\
    \      return chalk[showStyle_(style)];\
    \    }, localChalk)(string);\
    \  }\
    \}" :: [Style] -> String -> String

  foreign import unsafeCallChalk
    "function unsafeCallChalk(method) {\
    \  return function(x) {\
    \    return localChalk[method](x);\
    \  }\
    \}" :: forall a b. String -> a -> b
