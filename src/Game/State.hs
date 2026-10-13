-- | Ham tien ich de doc va cap nhat 'GameState' va tai nguyen.
module Game.State
    ( getPlayer
    , setPlayer
    , modifyPlayer
    , otherPlayer
    , planetAt
    , addResources
    , removeResources
    , totalUnits
    , resourcesValue
    , playerScore
    ) where

import Data.List (find)
import qualified Data.Map.Strict as Map

import Game.Config
import Game.Types

-- | Lay nguoi choi theo 'PlayerId'.
getPlayer :: PlayerId -> GameState -> Player
getPlayer Player1 = gsPlayer1
getPlayer Player2 = gsPlayer2

-- | Thay nguoi choi bang mot ban moi.
setPlayer :: PlayerId -> Player -> GameState -> GameState
setPlayer Player1 p gs = gs { gsPlayer1 = p }
setPlayer Player2 p gs = gs { gsPlayer2 = p }

-- | Ap dung mot ham len nguoi choi.
modifyPlayer :: PlayerId -> (Player -> Player) -> GameState -> GameState
modifyPlayer pid f gs = setPlayer pid (f (getPlayer pid gs)) gs

-- | Nguoi choi con lai.
otherPlayer :: PlayerId -> PlayerId
otherPlayer Player1 = Player2
otherPlayer Player2 = Player1

-- | Hanh tinh dang nam tai mot o (neu co).
planetAt :: Pos -> GameState -> Maybe Planet
planetAt pos gs = find ((== pos) . planetPos) (Map.elems (gsPlanets gs))

-- | Cong hai kho tai nguyen.
addResources :: Resources -> Resources -> Resources
addResources = Map.unionWith (+)

-- | Tru tai nguyen. Tra ve 'Nothing' neu kho khong du bat ky loai nao.
-- Ket qua khong chua loai co so luong 0.
removeResources :: Resources -> Resources -> Maybe Resources
removeResources have cost
    | any (< 0) (Map.elems diff) = Nothing
    | otherwise                  = Just (Map.filter (> 0) diff)
  where
    diff = Map.unionWith (+) have (Map.map negate cost)

-- | Tong so don vi tai nguyen.
totalUnits :: Resources -> Int
totalUnits = sum . Map.elems

-- | Tong diem cua mot kho tai nguyen.
resourcesValue :: Config -> Resources -> Int
resourcesValue cfg rs = sum
    [ n * Map.findWithDefault 0 t (cfgResourceValue cfg) | (t, n) <- Map.toList rs ]

-- | Diem cua nguoi choi (chi tinh kho Earth, khong tinh cargo).
playerScore :: Config -> Player -> Int
playerScore cfg = resourcesValue cfg . playerStorage