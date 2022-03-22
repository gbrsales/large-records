{-# LANGUAGE ConstraintKinds       #-}
{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE PolyKinds             #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE TypeFamilies          #-}

-- | Type-level rows
--
-- For each class defined here we additionally define the type of the
-- dictionary for the benefit of "Data.Record.Anonymous.Internal.Evidence".
--
-- NOTE: Apart from 'FieldTypes', none of the definitions in this module take
-- a functor argument (@f@). This is intentional: it makes then more general,
-- and moreover useable in both the advanced and the simple interface.
--
-- Intended for unqualified import.
module Data.Record.Anonymous.Internal.Row (
    -- * Subrecords
    Project(..)
  , DictProject
    -- * Merging records
  , Merge
    -- * Constraints
  , AllFields(..)
  , DictAllFields
    -- * Metadata
  , KnownFields(..)
  , DictKnownFields
  , FieldTypes
  , fieldNames
    -- * Reflection (internal usage only)
  , Reflected(..)
  , reflectKnownFields
  , reflectAllFields
  ) where

import Data.Kind
import Data.Proxy (Proxy)
import Data.Record.Generic (FieldMetadata(..))
import Data.SOP.Dict
import GHC.Exts (Any)
import GHC.TypeLits
import Unsafe.Coerce (unsafeCoerce)

import qualified Data.Vector as Lazy

{-------------------------------------------------------------------------------
  Subrecord
-------------------------------------------------------------------------------}

-- | Subrecords
--
-- This is a low-level class, instances of which are generated by the plugin.
-- See 'recordLens' for the user API.
class Project (r :: [(Symbol, k)]) (r' :: [(Symbol, k)]) where
  projectIndices :: DictProject k r r'

-- | In order of the fields in the /target/ record, the index in the /source/
type DictProject k (r :: [(Symbol, k)]) (r' :: [(Symbol, k)]) =
       Proxy r -> Proxy r' -> [Int]

{-------------------------------------------------------------------------------
  Merging records
-------------------------------------------------------------------------------}

-- | Merge two records
--
-- The 'Merge' type family does not reduce: the following two types are /not/
-- considered to be equal:
--
-- > Record '[ '("a", Bool) ']
-- > Record (Merge '[ '("a", Bool) '] '[])
--
-- They are /isomorphic/ (see 'castRecord'), but not /equal/.
--
-- As a consequence, the 'Merge' type family is injective: if
--
-- > Merge xs ys ~ Merge xs' ys'
--
-- then @xs ~ xs'@ and @ys ~ ys'@. Example:
--
-- >>> :{
--   let foo :: Merge '[ '("a", Bool) ] '[] ~ Merge '[] '[ '("a", Bool) ] => ()
--       foo = ()
--   in foo
-- :}
-- ...
-- ...Couldn't match...[]...
-- ...
--
-- See 'merge' for additional information.
type family Merge :: [(Symbol, Type)] -> [(Symbol, Type)] -> [(Symbol, Type)]

{-------------------------------------------------------------------------------
  Constraints
-------------------------------------------------------------------------------}

-- | Dictionary for @c x@ for each field of type @x@ in the row
--
-- Instances of this class are provided by the plugin.
class AllFields (r :: [(Symbol, k)]) (c :: k -> Constraint) where
  -- | Vector of dictionaries, in row order
  --
  -- This is a low-level function that should not be used in user code.
  -- Use 'constrain' or one of the constrained combinators such as 'cmap'.
  --
  -- This returns a /lazy/ vector because it is used to build a 'Rep'.
  fieldDicts :: DictAllFields k r c

type DictAllFields k (r :: [(Symbol, k)]) (c :: k -> Constraint) =
       Proxy r -> Proxy c -> Lazy.Vector (Dict c Any)

{-------------------------------------------------------------------------------
  Metadata
-------------------------------------------------------------------------------}

class KnownFields (r :: [(Symbol, k)]) where
  -- | Metadata for each field, in row order
  --
  -- This is a low-level function that should not be used in user code.
  fieldMetadata :: DictKnownFields k r

type DictKnownFields k (r :: [(Symbol, k)]) =
       Proxy r -> [FieldMetadata Any]

-- | Names of all fields, in row order
fieldNames :: KnownFields r => Proxy r -> [String]
fieldNames = map aux . fieldMetadata
  where
    aux :: FieldMetadata Any -> String
    aux (FieldMetadata p _strictness) = symbolVal p

type family FieldTypes (f :: k -> Type) (r :: [(Symbol, k)]) :: [(Symbol, Type)]
  -- Rewritten by the plugin

{-------------------------------------------------------------------------------
  Reflection

  Internal usage only.
-------------------------------------------------------------------------------}

data Reflected c where
  Reflected :: c => Reflected c

newtype WithKnownFields r = WKF (KnownFields r => Reflected (KnownFields r))

reflectKnownFields :: DictKnownFields k r -> Reflected (KnownFields r)
reflectKnownFields = unsafeCoerce (WKF Reflected)

newtype WithAllFields r c = WAF (AllFields r c => Reflected (AllFields r c))

reflectAllFields :: DictAllFields k r c -> Reflected (AllFields r c)
reflectAllFields = unsafeCoerce (WAF Reflected)
