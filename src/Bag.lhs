%
% (c) The GRASP/AQUA Project, Glasgow University, 1992-1996
%
\section[Bags]{@Bag@: an unordered collection with duplicates}

\begin{code}
module Bag (
	Bag,	-- abstract type

	emptyBag, unitBag, unionBags, unionManyBags,
	mapBag,
	elemBag,

	filterBag, partitionBag, concatBag, foldBag,
	isEmptyBag, consBag, snocBag,
	listToBag, bagToList
    ) where

import Data.List(partition)

data Bag a
  = EmptyBag
  | UnitBag	a
  | TwoBags	(Bag a) (Bag a)	-- The ADT guarantees that at least
				-- one branch is non-empty
  | ListBag	[a]		-- The list is non-empty
  | ListOfBags	[Bag a]		-- The list is non-empty

emptyBag :: Bag a
emptyBag = EmptyBag

unitBag :: a -> Bag a
unitBag  = UnitBag

elemBag :: Eq a => a -> Bag a -> Bool
elemBag _ EmptyBag        = False
elemBag x (UnitBag y)     = x==y
elemBag x (TwoBags b1 b2) = x `elemBag` b1 || x `elemBag` b2
elemBag x (ListBag ys)    = any (x ==) ys
elemBag x (ListOfBags bs) = any (x `elemBag`) bs

unionManyBags :: [Bag a] -> Bag a
unionManyBags [] = EmptyBag
unionManyBags xs = ListOfBags xs

-- This one is a bit stricter! The bag will get completely evaluated.
unionBags :: Bag a -> Bag a -> Bag a
unionBags EmptyBag b = b
unionBags b EmptyBag = b
unionBags b1 b2      = TwoBags b1 b2

consBag :: a -> Bag a -> Bag a
snocBag :: Bag a -> a -> Bag a

consBag elt bag = (unitBag elt) `unionBags` bag
snocBag bag elt = bag `unionBags` (unitBag elt)

isEmptyBag :: Bag a -> Bool
isEmptyBag EmptyBag	    = True
isEmptyBag (UnitBag _)	    = False
isEmptyBag (TwoBags b1 b2)  = isEmptyBag b1 && isEmptyBag b2	-- Paranoid, but safe
isEmptyBag (ListBag xs)     = null xs				-- Paranoid, but safe
isEmptyBag (ListOfBags bs)  = all isEmptyBag bs

filterBag :: (a -> Bool) -> Bag a -> Bag a
filterBag _ EmptyBag = EmptyBag
filterBag predic b@(UnitBag val) = if predic val then b else EmptyBag
filterBag predic (TwoBags b1 b2) = sat1 `unionBags` sat2
			       where
				 sat1 = filterBag predic b1
				 sat2 = filterBag predic b2
filterBag predic (ListBag vs)    = listToBag (filter predic vs)
filterBag predic (ListOfBags bs) = ListOfBags sats
				where
				 sats = [filterBag predic b | b <- bs]

concatBag :: Bag (Bag a) -> Bag a

concatBag EmptyBag 	    = EmptyBag
concatBag (UnitBag b)       = b
concatBag (TwoBags b1 b2)   = concatBag b1 `TwoBags` concatBag b2
concatBag (ListBag bs)	    = ListOfBags bs
concatBag (ListOfBags bbs)  = ListOfBags (map concatBag bbs)

partitionBag :: (a -> Bool) -> Bag a -> (Bag a {- Satisfy predictate -},
					 Bag a {- Don't -})
partitionBag _    EmptyBag = (EmptyBag, EmptyBag)
partitionBag predic b@(UnitBag val) = if predic val then (b, EmptyBag) else (EmptyBag, b)
partitionBag predic (TwoBags b1 b2) = (sat1 `unionBags` sat2, fail1 `unionBags` fail2)
				  where
				    (sat1,fail1) = partitionBag predic b1
				    (sat2,fail2) = partitionBag predic b2
partitionBag predic (ListBag vs)	  = (listToBag sats, listToBag fails)
				  where
				    (sats,fails) = partition predic vs
partitionBag predic (ListOfBags bs) = (ListOfBags sats, ListOfBags fails)
				  where
				    (sats, fails) = unzip [partitionBag predic b | b <- bs]


foldBag :: (r -> r -> r)	-- Replace TwoBags with this; should be associative
	-> (a -> r)		-- Replace UnitBag with this
	-> r			-- Replace EmptyBag with this
	-> Bag a
	-> r

{- Standard definition
foldBag t u e EmptyBag        = e
foldBag t u e (UnitBag x)     = u x
foldBag t u e (TwoBags b1 b2) = (foldBag t u e b1) `t` (foldBag t u e b2)
foldBag t u e (ListBag xs)    = foldr (t.u) e xs
foldBag t u e (ListOfBags bs) = foldr (\b r -> foldBag e u t b `t` r) e bs
-}

-- More tail-recursive definition, exploiting associativity of "t"
foldBag _ _ e EmptyBag        = e
foldBag t u e (UnitBag x)     = u x `t` e
foldBag t u e (TwoBags b1 b2) = foldBag t u (foldBag t u e b2) b1
foldBag t u e (ListBag xs)    = foldr (t.u) e xs
foldBag t u e (ListOfBags bs) = foldr (\b r -> foldBag t u r b) e bs


mapBag :: (a -> b) -> Bag a -> Bag b
mapBag _ EmptyBag 	 = EmptyBag
mapBag f (UnitBag x)     = UnitBag (f x)
mapBag f (TwoBags b1 b2) = TwoBags (mapBag f b1) (mapBag f b2)
mapBag f (ListBag xs)    = ListBag (map f xs)
mapBag f (ListOfBags bs) = ListOfBags (map (mapBag f) bs)


listToBag :: [a] -> Bag a
listToBag [] = EmptyBag
listToBag vs = ListBag vs

bagToList :: Bag a -> [a]
bagToList EmptyBag     = []
bagToList (ListBag vs) = vs
bagToList b = bagToList_append b []

    -- (bagToList_append b xs) flattens b and puts xs on the end.
    -- (not exported)
bagToList_append :: Bag a -> [a] -> [a]
bagToList_append EmptyBag 	 xs = xs
bagToList_append (UnitBag x)	 xs = x:xs
bagToList_append (TwoBags b1 b2) xs = bagToList_append b1 (bagToList_append b2 xs)
bagToList_append (ListBag xx)    xs = xx++xs
bagToList_append (ListOfBags bs) xs = foldr bagToList_append xs bs
\end{code}
