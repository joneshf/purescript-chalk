module Test.Main where

import Prelude

import Control.Monad.Aff          (Aff())
import Control.Monad.Eff          (Eff())
import Control.Monad.Eff.Console  (log)
import Data.Array                 (length)
import Data.Maybe                 (Maybe(..))
import Data.String.Regex          (Regex(), match, regex, noFlags, replace)
import Data.Traversable           (traverse)
import Test.Spec                  (describe, it)
import Test.Spec.Runner           (run)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.QuickCheck       (quickCheck)
import Test.QuickCheck            (Result(..), (===), (<?>))

import Data.String.Chalk

main = do
  traverse (log <<< someText) styles
  log $ chalk Reset $ chalk Bold "Here is some reset bold text"
  log $ chalk Bold $ chalk Reset "Here is some reset bold text"
  log $ chalk' [Reset, Bold] "Here is some reset bold text"
  log $ chalk' [Bold, Reset] "Here is some reset bold text"
  log $ chalk' [Bold, Underline] "Here is some bold, underlined, text"
  log ""
  supportsColor >>= (log <<< append "Terminal supports color: " <<< show)
  log ""
  traverse (log <<< info) styles
  run [consoleReporter] $ do
    describe "styles" do
      it "exists" do
        quickCheck (truthy styles)
    describe "textColors" $ do
      it "exists" do
        quickCheck (truthy textColors)
    describe "bgColors" do
      it "exists" do
        quickCheck (truthy bgColors)
    describe "typeStyles" do
      it "exists" do
        quickCheck (truthy typeStyles)
    describe "chalk" do
      it "exists" do
        quickCheck (truthy chalk)
      it "is total" do
        quickCheck \sty str -> const true (chalk sty str)
      it "adds ANSI codes" do
        quickCheck \sty str ->
          let codePatt = regexStr ansiRegex
              patt = regex (codePatt <> str <> codePatt) noFlags
          in if str /= ""
                then chalk sty str `matches` patt
                else Success
    describe "chalk'" do
      it "exists" do
        quickCheck (truthy chalk')
      it "is total" do
        quickCheck \stys str -> const true (chalk' stys str)
    describe "hasAnsi" do
      it "exists" do
        quickCheck (truthy hasAnsi)
      it "is total" do
        quickCheck \str -> const true (hasAnsi str)
      it "detects ANSI codes when present" do
        quickCheck \stys str ->
          let shouldHave = (length stys > 0) && str /= ""
              res = hasAnsi (chalk' stys str) == shouldHave
              exp = "stys: " <> show stys <> " string: " <> escape str
           in res <?> exp
    describe "stripAnsi" do
      it "exists" do
        quickCheck (truthy stripAnsi)
      it "is total" do
        quickCheck \str -> const true (stripAnsi str)
      it "removes codes added by chalk'" do
        quickCheck \stys str ->
          stripAnsi (chalk' stys str) === str
    describe "ansiRegex" do
      it "exists" do
        quickCheck (truthy ansiRegex)
      it "matches codes where present" do
        quickCheck \stys str ->
          let shouldHave = (length stys > 0) && str /= ""
              str' = chalk' stys str
           in if shouldHave
                 then str' `matches` ansiRegex
                 else str' `noMatch` ansiRegex
    describe "supportsColor" do
      it "exists" do
        quickCheck (truthy supportsColor)
    describe "ansiInfo" do
      it "exists" do
        quickCheck (truthy ansiInfo)
      it "has valid codes" do
        quickCheck \sty ->
          let inf = ansiInfo sty
           in (hasAnsi inf.open && hasAnsi inf.close) <?> "style: " <> show sty

foreign import truthy :: forall a. a -> Boolean
foreign import escape :: String -> String

someText :: Style -> String
someText style = chalk style $ "Here is some " <> show style <> " text"

info :: Style -> String
info style = show style
          <> " open: " <> escape inf.open
          <> " close: " <> escape inf.close
  where inf = ansiInfo style

regexStr :: Regex -> String
regexStr = cutBack <<< cutFront <<< show
  where cutFront = replace (regex "^.*?/" noFlags) ""
        cutBack  = replace (regex "/.*?$" noFlags) ""

matches :: String -> Regex -> Result
matches str patt = case match patt str of
  Nothing -> Failed ("Could not match " <> escape str <> " with " <> show patt)
  Just _  -> Success

noMatch :: String -> Regex -> Result
noMatch str patt = case match patt str of
  Nothing -> Success
  Just _  -> Failed (escape str <> " should not match " <> show patt)
