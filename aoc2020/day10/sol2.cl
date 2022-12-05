#!/bin/sbcl --script
(load "../common.cl")

(defparameter *adapters* '())
(read-syms-list *adapters*)

(defparameter
  *dev*
  (+ 3 (apply 'max *adapters*)))

(setf *adapters* (append *adapters* (list *dev*)))

(defun factorial (n &optional (a 1))
  (if (< n 2) a (factorial (- n 1) (* a n))))

(defparameter *memo* '())

(defun check-ways
  (&optional
    (ad (cdr *adapters*))
    (prev 0)
    (cur (car *adapters*)))
  (if ad
    (let*
      ((next (car ad))
       (rst (cdr ad))
       (args (list prev cur next))
       (memv (member args *memo* :test
		     (lambda (x y)
		       (equal x (car y))))))
      (if memv
	(cdar memv)
	(let
	  ((v
	     (+ (check-ways rst cur next)
		(if (< (- next prev) 4)
		  (check-ways rst prev next)
		  0))))
	  (setf
	    *memo*
	    (append
	      (list
		(cons
		  args
		  v))
	      *memo*))
	  v)))
    1))

(write (check-ways))
(terpri)
