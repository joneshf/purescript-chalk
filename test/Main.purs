module Test.Main where

import Prelude

import Control.Monad.Eff.Console  (log)
import Data.Traversable           (traverse)
import Test.Spec                  (describe, it)
import Test.Spec.Runner           (run)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.QuickCheck       (quickCheck)

import Data.String.Chalk

main = do
  traverse (log <<< someText) styles
  log $ chalk Reset $ chalk Bold "Here is some reset bold text"
  log $ chalk Bold $ chalk Reset "Here is some reset bold text"
  log $ chalk' [Reset, Bold] "Here is some reset bold text"
  log $ chalk' [Bold, Reset] "Here is some reset bold text"
  log $ chalk' [Bold, Underline] "Here is some bold, underlined, text"
  log ""
  run [consoleReporter] $ do
    describe "styles" do
      it "exists" do
        quickCheck (truthy styles)
    describe "chalk" do
      it "exists" do
        quickCheck (truthy chalk)
      it "is total" do
        quickCheck \sty str -> const true (chalk sty str)
    describe "chalk'" do
      it "exists" do
        quickCheck (truthy chalk')
      it "is total" do
        quickCheck \stys str -> const true (chalk' stys str)

foreign import truthy :: forall a. a -> Boolean

someText :: Style -> String
someText style = chalk style $ "Here is some " <> show style <> " text"
