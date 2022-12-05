#!/bin/sbcl --script
(load "../common.cl")

(let
  ((prev 0)
   (ones 0)
   (threes 0))
  (do
    ((num (rs) (rs)))
    ((null num))
    (let
      ((d (- num prev)))
      (if (= d 1)
	(incf ones)
	(if (= d 3)
	  (incf threes)))
      (setf prev num)))
  (incf threes)
  (write (* ones threes))
  (terpri))
