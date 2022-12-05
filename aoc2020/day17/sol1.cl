#!/bin/sbcl --script
(load "read.cl")
(load "eval.cl")

(defparameter *space* nil)
(defparameter *steps* 6)

(defparameter *size*
  (read-space *space* *steps*))
(defparameter *new-space*
  (make-array (list (nth 0 *size*)
		    (nth 1 *size*)
		    (nth 2 *size*))
	      :initial-element #\.))
(defparameter *start* (mapcar (lambda (x) (- x 1)) *size*))

(do ((st *steps* (- st 1)))
  ((zerop st))
  (eval-step *space* *new-space*
	     (nth 0 *start*)
	     (nth 1 *start*)
	     (nth 2 *start*))
  (let
    ((tmp *new-space*))
    (setf *new-space* *space*)
    (setf *space* tmp)))

(defun count-row (spc xs ys zs xe ye ze v)
  (if (> zs ze)
    v
    (count-row
      spc xs ys (+ zs 1) xe ye ze
      (+ v (charv (aref spc xs ys zs))))))

(defun count-flat (spc xs ys zs xe ye ze v)
  (if (> ys ye)
    v
    (count-flat
      spc xs (+ ys 1) zs xe ye ze
      (count-row spc xs ys zs xe ye ze v))))

(defun count-active (spc xs ys zs xe ye ze v)
  (if (> xs xe)
    v
    (count-active
      spc (+ xs 1) ys zs xe ye ze
      (count-flat spc xs ys zs xe ye ze v))))

(print (count-active
	 *space* 0 0 0
	 (nth 0 *start*)
	 (nth 1 *start*)
	 (nth 2 *start*)
	 0))
(terpri)
