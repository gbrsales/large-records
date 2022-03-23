{-# LANGUAGE ConstraintKinds           #-}
{-# LANGUAGE DataKinds                 #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE FlexibleInstances         #-}
{-# LANGUAGE MultiParamTypeClasses     #-}
{-# LANGUAGE ScopedTypeVariables       #-}
{-# LANGUAGE StandaloneDeriving        #-}
{-# LANGUAGE TypeFamilies              #-}
{-# LANGUAGE UndecidableInstances      #-}

#if PROFILE_CORESIZE
{-# OPTIONS_GHC -ddump-to-file -ddump-ds-preopt -ddump-ds -ddump-simpl #-}
#endif
#if PROFILE_TIMING
{-# OPTIONS_GHC -ddump-to-file -ddump-timings #-}
#endif

{-# OPTIONS_GHC -fplugin=Data.Record.Plugin #-}

module HigherKinded.Sized.R020 where

import Bench.Types

{-# ANN type R largeRecordStrict #-}
data R f = MkR {
      -- 1 .. 10
      field1  :: HK 1  f
    , field2  :: HK 2  f
    , field3  :: HK 3  f
    , field4  :: HK 4  f
    , field5  :: HK 5  f
    , field6  :: HK 6  f
    , field7  :: HK 7  f
    , field8  :: HK 8  f
    , field9  :: HK 9  f
    , field10 :: HK 10 f
      -- 11 .. 20
    , field11 :: HK 11 f
    , field12 :: HK 12 f
    , field13 :: HK 13 f
    , field14 :: HK 14 f
    , field15 :: HK 15 f
    , field16 :: HK 16 f
    , field17 :: HK 17 f
    , field18 :: HK 18 f
    , field19 :: HK 19 f
    , field20 :: HK 20 f
    }
  deriving (Eq, Show)
