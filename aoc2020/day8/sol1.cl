#!/bin/sbcl --script

(defparameter *instructions*
  (make-array 1024 :fill-pointer 0))
(defparameter *acc* 0)
(defparameter *cur* 0)

(defmacro rs ()
  '(read t nil nil))

(defun get-instr
    (&optional
      (instr '()))
  (let
      ((s1 (rs))
       (s2 (rs)))
    (if s1
	(cons
	  (cons s1 s2)
	  0)
	nil)))

(do ((sym
       (get-instr)
       (get-instr)))
    ((null sym))
    (vector-push-extend sym *instructions*))

(do* ((instr
       (aref *instructions* *cur*)
       (aref *instructions* *cur*))
      (in (caar instr)
	  (caar instr))
      (num (cdar instr)
	   (cdar instr))
      (ex (cdr instr)
	  (cdr instr)))
    ((or (null instr)
	 (not (zerop ex))))
  (setf (aref *instructions* *cur*)
	(cons (cons in num) (+ ex 1)))
  (if (equal 'jmp in)
      (setf *cur*
	    (+ *cur* num))
      (progn
	(if (equal 'acc in)
	    (setf *acc*
		  (+ *acc* num)))
	(incf *cur*))))

(write *acc*)
(terpri)
