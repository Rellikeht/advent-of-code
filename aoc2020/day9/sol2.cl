#!/bin/sbcl --script

(defmacro rs ()
  '(read t nil nil))

(defparameter *target* 167829540)
(defparameter *nums* '())

(do ((num (rs) (rs)))
  ((null num))
  (setf *nums*
	(append *nums*
		(list num))))

(defparameter *nums-size* (length *nums*))

(defun search-target
  (&optional
    (nums *nums*)
    (frag '())
    (sum 0))
  (if (= sum *target*)
    frag
    (if nums
      (let*
	((num (car nums))
	 (rst (cdr nums))
	 (nsum (+ sum num)))
	(if (> nsum *target*)
	  (if frag
	    (search-target
	      nums
	      (cdr frag)
	      (- sum (car frag)))
	    nil)
	  (search-target
	    rst
	    (append frag (list num))
	    nsum)))
      nil)))

(defparameter fnd (search-target))
(if fnd
  (format t "~A~%~%~A ~A~%~A~%"
	  fnd
	  (apply 'max fnd)
	  (apply 'min fnd)
	  (reduce '+ fnd))
  (format t "HUJA~%"))
