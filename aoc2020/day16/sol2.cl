#!/bin/sbcl --script
(load "read.cl")
(load "check.cl")

(read-syms-list *fields* read-field)
(rl)
(setf *my-ticket* (read-ticket))
(rl)
(rl)
(read-syms-list *tickets* read-ticket)

(defparameter *good* (good-tickets *tickets* *fields*))
(defparameter *fields-amount* (length *fields*))
(defparameter *sfields* (make-array *fields-amount*))

(do ((i (- *fields-amount* 1) (- i 1)))
  ((< i 0))
  (setf (aref *sfields* i) *fields*))

(do ((ts *good* (cdr ts)))
  ((null ts))
  (update-matches (car ts) *sfields*))

(defun remove-field (arr field pres &optional
			 (i (- (length arr) 1))
			 (changed nil))
  (if (>= i 0)
    (if (= i pres)
      (remove-field arr field pres (- i 1) changed)
      (let*
	((fields (aref arr i))
	 (nf (remove field fields :test 'equal))
	 (ni (- i 1)))
	(if (equal nf fields)
	  (remove-field arr field pres ni changed)
	  (progn
	    (setf (aref arr i) nf)
	    (remove-field arr field pres ni t)))))
    changed))

(defun remove-singles (arr &optional
		       (i (- (length arr) 1))
		       (changed nil))
  (if (>= i 0)
    (let
      ((fields (aref arr i))
       (ni (- i 1)))
      (if (= 1 (length fields))
	(remove-singles
	  arr ni
	  (or changed
	      (remove-field arr (car fields) i)))
	(remove-singles arr ni changed)))
    changed))

(do ((ch (remove-singles *sfields*)
	 (remove-singles *sfields*)))
  ((null ch)))

(do ((i 0 (+ i 1))
     (f *my-ticket* (cdr f))
     (m 1))
  ((null f)
   (print m)
   (terpri))
  (let*
    ((ti (car f))
     (r (aref *sfields* i))
     (n (cdar r))
     (sp (split n #\ ))
     (ss (car sp))
     (sn (cdr sp)))
    (if (string= ss "departure")
      (progn
	(setf m (* m ti))))))
