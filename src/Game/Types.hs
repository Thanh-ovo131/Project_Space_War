-- | Cac kieu du lieu cot loi cua game (chi la du lieu, chua co luat choi).
--
-- Luat choi nam o cac module khac (@Game.World@, @Game.Action@, ...).

module Game.Types
    ( -- * Vi tri va huong
      Pos (..)
    , Direction (..)
    , Compass (..)
      -- * Tai nguyen
    , ResourceType (..)
    , Resources
      -- * Hanh tinh
    , PlanetType (..)
    , PlanetId
    , Planet (..)
    , KnownPlanet (..)
      -- * Nguoi choi
    , PlayerId (..)
    , Player (..)
      -- * Trang thai game
    , WinReason (..)
    , GameResult (..)
    , GamePhase (..)
    , GameState (..)
      -- * Hanh dong
    , Action (..)
    , GameError (..)
    , Notice (..)
    , ActionResult (..)
    , ActionReport (..)
    ) where

import qualified Data.Map.Strict as Map
import System.Random (StdGen)

-- | Toa do tren map. @posX@ tang sang phai, @posY@ tang xuong duoi.
data Pos = Pos
    { posX :: Int
    , posY :: Int
    } deriving (Show, Eq, Ord)

-- | Bon huong di chuyen. 'DirUp' lam giam @posY@ di 1.
data Direction = DirUp | DirDown | DirLeft | DirRight
    deriving (Show, Eq, Ord, Enum, Bounded)

-- | Tam huong (8 phia) dung cho ket qua scan. 'Here' nghia la cung o.
data Compass
    = North | NorthEast | East | SouthEast
    | South | SouthWest | West | NorthWest
    | Here
    deriving (Show, Eq, Ord, Enum, Bounded)

-- | Nam loai tai nguyen.
data ResourceType = Iron | Crystal | EnergyCore | RareOre | ExoticMatter
    deriving (Show, Eq, Ord, Enum, Bounded)

-- | So luong tung loai tai nguyen (loai khong co trong bang nghia la 0).
type Resources = Map.Map ResourceType Int

-- | Ba loai hanh tinh cua ban MVP.
data PlanetType = Mining | Energy | Rare
    deriving (Show, Eq, Ord, Enum, Bounded)

-- | Ma so cua hanh tinh (1, 2, 3, ...).
type PlanetId = Int

-- | Mot hanh tinh. 'planetStock' la ton kho con lai, dung chung cho hai nguoi.
data Planet = Planet
    { planetId    :: PlanetId
    , planetPos   :: Pos
    , planetType  :: PlanetType
    , planetStock :: Resources
    } deriving (Show, Eq)

-- | Thong tin ve mot hanh tinh ma nguoi choi da kham pha (vi tri va loai).
data KnownPlanet = KnownPlanet
    { knownPos  :: Pos
    , knownType :: PlanetType
    } deriving (Show, Eq)

-- | Hai nguoi choi.
data PlayerId = Player1 | Player2
    deriving (Show, Eq, Ord, Enum, Bounded)

-- | Trang thai cua mot nguoi choi.
data Player = Player
    { playerPos     :: Pos
    , playerBattery :: Int
    , playerAP      :: Int
    , playerCargo   :: Resources                      -- ^ kho tren tau
    , playerStorage :: Resources                      -- ^ kho rieng tai Earth
    , playerKnown   :: Map.Map PlanetId KnownPlanet   -- ^ hanh tinh da kham pha
    } deriving (Show, Eq)

-- | Ly do thang.
data WinReason
    = ReachedTarget          -- ^ du diem o kho Earth
    | OpponentOutOfBattery   -- ^ doi thu het battery
    | OpponentDisconnected   -- ^ doi thu mat ket noi
    | HigherScoreAtLimit     -- ^ het so vong, diem Earth cao hon
    deriving (Show, Eq)

-- | Ket qua cua mot tran.
data GameResult
    = Winner PlayerId WinReason
    | Draw
    deriving (Show, Eq)

-- | Giai doan cua tran dau.
data GamePhase
    = WaitingForPlayers
    | InProgress
    | Finished GameResult
    deriving (Show, Eq)

-- | Toan bo trang thai cua mot tran. Server giu ban day du nay.
data GameState = GameState
    { gsMapWidth  :: Int
    , gsMapHeight :: Int
    , gsEarth     :: Pos
    , gsPlanets   :: Map.Map PlanetId Planet
    , gsPlayer1   :: Player
    , gsPlayer2   :: Player
    , gsCurrent   :: PlayerId     -- ^ nguoi dang co luot
    , gsRound     :: Int          -- ^ vong hien tai (1 vong = luot P1 roi luot P2)
    , gsPhase     :: GamePhase
    , gsRng       :: StdGen       -- ^ bo sinh so ngau nhien
    } deriving (Show, Eq)


    -- | Cac hanh dong nguoi choi co the lam trong luot cua minh.
data Action
    = Move Direction
    | Observe
    | ScanArea
    | ScanNearest
    | ScanOpponent
    | Mine ResourceType
    | Deposit
    | Recharge ResourceType Int   -- ^ loai tai nguyen va so luong dung de nap
    | EndTurn
    deriving (Show, Eq)

-- | Ly do mot action bi tu choi (khi bi tu choi thi khong mat gi).
data GameError
    = GameNotInProgress       -- ^ tran chua bat dau hoac da ket thuc
    | NotYourTurn
    | NotEnoughAP
    | NotEnoughBattery
    | OutOfBounds             -- ^ di ra ngoai map
    | NotOnPlanet             -- ^ Mine khi khong dung tren hanh tinh
    | PlanetHasNoSuchResource -- ^ hanh tinh khong con loai tai nguyen do
    | CargoFull
    | CargoEmpty              -- ^ Deposit khi cargo rong
    | NotAtEarth              -- ^ Recharge khi khong dung o Earth
    | OutOfDepositRange       -- ^ Deposit khi qua xa Earth
    | BatteryFull             -- ^ Recharge khi battery da day
    | NotEnoughResources      -- ^ kho Earth khong du tai nguyen de nap
    | InvalidAmount           -- ^ so luong khong hop le (<= 0)
    deriving (Show, Eq)

-- | Thong bao gui cho doi thu khi ban lam mot action.
data Notice = YouWereScanned
    deriving (Show, Eq)

-- | Ket qua rieng cua tung action danh cho nguoi hanh dong.
data ActionResult
    = Moved Pos
    | PlanetsFound [KnownPlanet]
    | NearestPlanet (Maybe (Compass, Int))   -- ^ huong va khoang cach, hoac khong con hanh tinh
    | OpponentDirection Compass
    | Mined ResourceType Int
    | Deposited Resources
    | Recharged Int                          -- ^ so battery thuc su nhan duoc
    | TurnEnded
    deriving (Show, Eq)

-- | Bao cao cua mot action thanh cong.
data ActionReport = ActionReport
    { reportResult :: ActionResult
    , reportNotice :: Maybe Notice   -- ^ thong bao cho doi thu, neu co
    } deriving (Show, Eq)