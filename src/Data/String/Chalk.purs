module Data.String.Chalk
  ( Style(..)
  , styles
  , textColors
  , bgColors
  , typeStyles
  , chalk
  , chalk'
  , hasAnsi
  , stripAnsi
  , ansiRegex
  , supportsColor
  , ansiInfo
  ) where

import Prelude

import Control.Monad.Eff         (Eff())
import Control.Monad.Eff.Console (CONSOLE())
import Data.Array                (uncons)
import Data.Foldable             (foldl)
import Data.Maybe                (Maybe(..))
import Data.String.Regex         (Regex())
import Data.StrMap               (StrMap())
import Unsafe.Coerce             (unsafeCoerce)
import Test.QuickCheck.Arbitrary (Arbitrary, arbitrary)
import Test.QuickCheck.Gen       (elements)

foreign import data Chalk :: *
foreign import data Builder :: *

-- Internal
foreign import localChalk :: Chalk

-- Internal
foreign import ansiStyles :: StrMap { open :: String, close :: String }

-- | Returns whether the string is styled (contains ANSI codes).
foreign import hasAnsi :: String -> Boolean

-- | Removes all styling (ANSI codes) from the string.
foreign import stripAnsi :: String -> String

-- | Regex for matching ANSI codes.
foreign import ansiRegex :: Regex

-- | Return whether the current terminal supports color. The JavaScript Chalk
-- | automatically prevents styling for terminals not supporting it. This
-- | has been disabled for this library.
foreign import supportsColor :: forall eff. Eff (console :: CONSOLE | eff) Boolean

-- Internal
foreign import unsafeGet :: forall o a. String -> o -> a

-- | ANSI styles supported by Chalk. `Italic` and `Strikethrough` are not
-- | widely supported and `Blue` and `BgBlue` will automatically be changed
-- | to light blue on Windows for legibility.
           -- General
data Style = Bold
           | Dim
           | Hidden
           | Inverse
           | Italic -- (not widely supported)
           | Reset
           | Strikethrough -- (not widely supported)
           | Underline
           -- Text colors
           | Black
           | Blue
           | Cyan
           | Gray
           | Green
           | Magenta
           | Red
           | White
           | Yellow
           -- Background colors
           | BgBlack
           | BgBlue
           | BgCyan
           | BgGreen
           | BgMagenta
           | BgRed
           | BgWhite
           | BgYellow

-- | All styles excluding `Reset`.
styles :: Array Style
styles = textColors <> bgColors <> typeStyles

-- | All text coloring styles.
textColors :: Array Style
textColors = [Black, Blue, Cyan, Gray, Green, Magenta, Red, White, Yellow]

-- | All background coloring styles.
bgColors :: Array Style
bgColors = [BgBlack, BgBlue, BgCyan, BgGreen, BgMagenta, BgRed, BgWhite, BgYellow]

-- | All non-coloring styles, excluding `Reset`.
typeStyles :: Array Style
typeStyles = [Bold, Dim, Hidden, Inverse, Italic, Strikethrough, Underline]

-- | Style a string with the given style. Unlike the JavaScript Chalk, this
-- | will add the styling regardless of whether it is supported by the current
-- | terminal. Note that `chalk` is effectful in that it changes its blue color
-- | depending on whether it is on Windows.
chalk :: Style -> String -> String
chalk style = build (mkBuilder style localChalk)

-- | The same as `chalk` but for multiple styles. In case of conflict
-- | (e.g. multiple colors or a `Reset`), the later style will generally take
-- | precedence, however both styles are added and so it is dependent on the
-- | terminal's rendering.
chalk' :: Array Style -> String -> String
chalk' stys str = case uncons stys of
                   Nothing -> str
                   Just x ->
                     let iter = flip styleBuilder
                         init = mkBuilder x.head localChalk
                      in build (foldl iter init x.tail) str


-- | The opening and closing ANSI code for a styles.
ansiInfo :: Style -> { open :: String, close :: String }
ansiInfo style = unsafeGet (show style) ansiStyles

-- Instances ------------------------------------------------------------------
instance showStyle :: Show Style where
  show BgBlack       = "bgBlack"
  show BgBlue        = "bgBlue"
  show BgCyan        = "bgCyan"
  show BgGreen       = "bgGreen"
  show BgMagenta     = "bgMagenta"
  show BgRed         = "bgRed"
  show BgWhite       = "bgWhite"
  show BgYellow      = "bgYellow"
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

instance arbStyle :: Arbitrary Style where
  arbitrary = elements Reset styles

-- Builder Functions ----------------------------------------------------------
mkBuilder :: Style -> Chalk -> Builder
mkBuilder style chlk = unsafeGet (show style) chlk

styleBuilder :: Style -> Builder -> Builder
styleBuilder style builder = unsafeGet (show style) builder

build :: Builder -> String -> String
build = unsafeCoerce
