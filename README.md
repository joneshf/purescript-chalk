# Module Documentation

## Module Data.String.Chalk

### Types

    data Style where
      Bold :: Style
      Dim :: Style
      Hidden :: Style
      Inverse :: Style
      Italic :: Style
      Reset :: Style
      Strikethrough :: Style
      Underline :: Style
      Black :: Style
      Blue :: Style
      Cyan :: Style
      Gray :: Style
      Green :: Style
      Magenta :: Style
      Red :: Style
      White :: Style
      Yellow :: Style
      BgBlack :: Style
      BgBlue :: Style
      BgCyan :: Style
      BgGreen :: Style
      BgMagenta :: Style
      BgRed :: Style
      BgWhite :: Style
      BgYellow :: Style


### Type Class Instances

    instance showStyle :: Show Style


### Values

    chalk :: Style -> String -> String

    chalk' :: [Style] -> String -> String

    hasColor :: String -> Boolean

    stripColor :: String -> String



