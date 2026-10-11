-- | Module chính của package @space-war@.
--
-- Các module game (@Game.*@) sẽ được re-export tại đây ở các phase sau.
module Lib
    ( someFunc
    , projectName
    , module Game.Types
    , module Game.Config
    , module Game.World
    , module Game.Generate
    ) where

import Game.Config
import Game.Generate
import Game.Types
import Game.World

-- | In một dòng chào mẫu (giữ lại từ template của stack).
someFunc :: IO ()
someFunc = putStrLn "someFunc"

-- | Tên của project.
--
-- Ví dụ:
--
-- >>> projectName
-- "space-war"
projectName :: String
projectName = "space-war"
