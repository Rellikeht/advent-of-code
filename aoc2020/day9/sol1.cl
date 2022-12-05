#!/bin/sbcl --script

(defmacro rs ()
  '(read t nil nil))

(defparameter *sums* '())
(defparameter *nums* '())
(defparameter *sums-size* 24)

(defun sum (n nums m &optional (s '()) (i 0))
  (if nums
    (if (= m i)
      (sum
	n (cdr nums)
	m s (+ i 1))
      (sum
	n (cdr nums)
	m (append
	    (list
	      (+ (car nums) n))
	    s) (+ i 1)))
    s))

(defun gen-sums ()
  (do* ((size *sums-size* (decf size))
	(num (rs) (rs))
	(nums (list num)
	      (append
		nums
		(list num))))
    ((zerop size)
     (setf *nums* nums)
     (do* ((ns nums (cdr ns))
	   (ind 0 (+ ind 1)))
       ((null ns)
	*sums*)
       (let*
	 ((n (car ns))
	  (sums
	    (sum n nums ind)))
	 (setf
	   *sums*
	   (append
	     *sums*
	     (list sums))))))
    ()))

(gen-sums)

(defun update-sums (&optional num (rs))
  (setf *sums* (cdr *sums*))
  (setf *nums* (append
		 (cdr *nums*)
		 (list num)))
  (setf *sums*
	(append
	  *sums*
	  (list
	    (sum
	      num *nums*
	      *sums-size*)))))

(defun is-valid (n &optional (sums *sums*))
  (if sums
    (let
      ((m (member n (car sums))))
      (if m
	m
	(is-valid n (cdr sums))))
    nil))

(let
  ((last_num
     (do
       ((num (rs) (rs)))
       ((or (null num)
	    (not (is-valid num)))
	num)
       (update-sums num))))
  (terpri)
  (write last_num)
  (terpri))
