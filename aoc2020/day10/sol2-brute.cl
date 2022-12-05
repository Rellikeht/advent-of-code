#!/bin/sbcl --script

(defmacro rs ()
  '(read t nil nil))

(defparameter *adapters* '())
;(defparameter *ways* 1)

(do
  ((num (rs) (rs)))
  ((null num))
  (setf
    *adapters*
    (append
      *adapters*
      (list num))))

(defparameter
  *dev*
  (+ 3 (apply 'max *adapters*)))

(setf *adapters* (append *adapters* (list *dev*)))

(defun factorial (n &optional (a 1))
  (if (< n 2) a (factorial (- n 1) (* a n))))

(defun check-ways
  (&optional
    (ad (cdr *adapters*))
    (prev 0)
    (cur (car *adapters*)))
  (if ad
    (let
      ((next (car ad))
       (rst (cdr ad)))
      (+ (check-ways rst cur next)
	 (if (< (- next prev) 4)
	   (check-ways rst prev next)
	   0)))
    1))

(write (check-ways))
(terpri)
