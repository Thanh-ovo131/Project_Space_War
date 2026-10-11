import Test.Hspec
import Test.QuickCheck
import Lib (projectName)

import qualified Game.WorldSpec

main :: IO ()
main = hspec $ do
  describe "Lib" $
    it "projectName is space-war" $
      projectName `shouldBe` "space-war"
  describe "QuickCheck" $
    it "addition is commutative" $
      property $ \x y -> (x + y) == (y + (x :: Int))
  describe "Game.World" Game.WorldSpec.spec