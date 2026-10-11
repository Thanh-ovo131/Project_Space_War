-- | Moi thong so cua game nam o day de chinh sua o mot cho.
--
-- Cac con so trong 'defaultConfig' la gia tri tam, se can bang lai sau.
module Game.Config
    ( Cost (..)
    , Config (..)
    , defaultConfig
    , earthPosition
    ) where

import qualified Data.Map.Strict as Map

import Game.Types

-- | Chi phi cua mot action.
data Cost = Cost
    { costAP      :: Int
    , costBattery :: Int
    } deriving (Show, Eq)

-- | Cac thong so cua game.
data Config = Config
    { cfgMapWidth         :: Int
    , cfgMapHeight        :: Int
    , cfgPlanetCounts     :: Map.Map PlanetType Int   -- ^ so hanh tinh moi loai
    , cfgPlanetStock      :: Map.Map PlanetType Resources  -- ^ ton kho ban dau moi loai
    , cfgPlanetMinEarthDist :: Int                    -- ^ hanh tinh cach Earth toi thieu
    , cfgSpawnMinDist     :: Int
    , cfgSpawnMaxDist     :: Int
    , cfgBatteryMax       :: Int
    , cfgApMax            :: Int
    , cfgCargoCapacity    :: Int
    , cfgObserveRadius    :: Int
    , cfgScanRadius       :: Int
    , cfgMineAmount       :: Int                      -- ^ toi da moi lan Mine
    , cfgDepositRange     :: Int                      -- ^ tam gui hang ve Earth
    , cfgRechargeRate     :: Int                      -- ^ battery nhan duoc cho 1 diem tai nguyen
    , cfgResourceValue    :: Map.Map ResourceType Int -- ^ diem moi don vi
    , cfgScoreTarget      :: Int
    , cfgMaxRounds        :: Int
    , cfgCostMove         :: Cost
    , cfgCostObserve      :: Cost
    , cfgCostScanArea     :: Cost
    , cfgCostScanNearest  :: Cost
    , cfgCostScanOpponent :: Cost
    , cfgCostMine         :: Cost
    , cfgCostDepositAtEarth :: Cost
    , cfgCostDepositRemote  :: Cost
    , cfgCostRecharge     :: Cost
    } deriving (Show, Eq)

-- | Cau hinh mac dinh theo spec v1.0.
defaultConfig :: Config
defaultConfig = Config
    { cfgMapWidth         = 100
    , cfgMapHeight        = 100
    , cfgPlanetCounts     = Map.fromList [(Mining, 40), (Energy, 24), (Rare, 16)]
    , cfgPlanetStock      = Map.fromList
        [ (Mining, Map.fromList [(Iron, 80), (Crystal, 30)])
        , (Energy, Map.fromList [(EnergyCore, 30), (Iron, 20)])
        , (Rare,   Map.fromList [(RareOre, 8), (ExoticMatter, 2)])
        ]
    , cfgPlanetMinEarthDist = 4
    , cfgSpawnMinDist     = 1
    , cfgSpawnMaxDist     = 5
    , cfgBatteryMax       = 100
    , cfgApMax            = 5
    , cfgCargoCapacity    = 50
    , cfgObserveRadius    = 3
    , cfgScanRadius       = 8
    , cfgMineAmount       = 5
    , cfgDepositRange     = 5
    , cfgRechargeRate     = 2
    , cfgResourceValue    = Map.fromList
        [(Iron, 1), (Crystal, 3), (EnergyCore, 5), (RareOre, 10), (ExoticMatter, 25)]
    , cfgScoreTarget      = 500
    , cfgMaxRounds        = 100
    , cfgCostMove         = Cost 1 2
    , cfgCostObserve      = Cost 1 1
    , cfgCostScanArea     = Cost 2 3
    , cfgCostScanNearest  = Cost 2 3
    , cfgCostScanOpponent = Cost 3 3
    , cfgCostMine         = Cost 2 1
    , cfgCostDepositAtEarth = Cost 1 0
    , cfgCostDepositRemote  = Cost 1 2
    , cfgCostRecharge     = Cost 1 0
    }

-- | Vi tri Earth: giua map (rong chia 2, cao chia 2). Mac dinh la (50, 50).
earthPosition :: Config -> Pos
earthPosition cfg = Pos (cfgMapWidth cfg `div` 2) (cfgMapHeight cfg `div` 2)