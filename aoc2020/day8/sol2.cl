#!/bin/sbcl --script

(defparameter *instructions*
  (make-array 1024
	      :fill-pointer 0
	      :initial-element nil))
(defparameter *acc* 0)
(defparameter *cur* 0)

(defmacro rs ()
  '(read t nil nil))

(defparameter *instr-len* 0)
(defun get-instr
    (&optional
      (instr '()))
  (let
      ((s1 (rs))
       (s2 (rs)))
    (if s1
      (cons s1 s2)
      nil)))

(do ((sym
       (get-instr)
       (get-instr)))
    ((null sym))
    (incf *instr-len*)
    (vector-push-extend sym *instructions*))

(defparameter *instr-usage* (make-array (+ *instr-len* 1) :initial-element 0))
(setf (aref *instr-usage* *instr-len*) nil)

(defparameter jnt (make-hash-table))
(setf (gethash 'jmp jnt) 'nop)
(setf (gethash 'nop jnt) 'jmp)

(defun check-path (instrn acc &optional (used '()))
  (let*
    ((instr (aref *instructions* instrn))
     (in (car instr))
     (num (cdr instr))
     (ex (aref *instr-usage* instrn)))
;    (format t "~A ~A ~A~%" instrn ex used)
    (if instr
      (if ex
	(if (zerop ex)
	  (let
	    ((newu (append (list instrn) used)))
	    (incf (aref *instr-usage* instrn))
	    (if (equal 'jmp in)
	      (check-path
		(+ instrn num)
		acc
		newu)
	      (if (equal 'acc in)
		(check-path
		  (+ instrn 1)
		  (+ acc num)
		  newu)
		(check-path
		  (+ instrn 1)
		  acc
		  newu))))
	  used)
	acc)
      acc)))

(defun fill-zeros (arr ind)
  (if ind
    (let
      ((i (car ind))
       (ni (cdr ind)))
      (setf (aref arr i) 0)
      (fill-zeros arr ni))
    t))

(do* ((instr
	(aref *instructions* *cur*)
	(aref *instructions* *cur*)))
  ((null instr)
   *acc*)
  (let
    ((in (car instr))
     (num (cdr instr))
     (ex (aref *instr-usage* *cur*)))
;    (format t "> ~A ~A~%" *cur* ex)
    (if (zerop ex)
      (progn
	(if (or (equal 'jmp in)
		(equal 'nop in))
	  (progn
	    (setf (car (aref *instructions* *cur*))
		  (gethash in jnt))
	    (let
	      ((check-res
		 (check-path
		   *cur*
		   *acc*)))
	      (if (numberp check-res)
		(progn
		  (setf *acc* check-res)
		  (setf *cur* 1022))
		(progn
		  (setf (car (aref *instructions* *cur*))
			(gethash in jnt))
		  (fill-zeros *instr-usage* check-res)
		  (if (equal 'jmp in)
		    (setf *cur* (+ *cur* num -1)))))))
	  (progn
	    (setf *acc* (+ *acc* num))))
	(if (<= *cur* *instr-len*)
	  (incf (aref *instr-usage* *cur*)))
	(incf *cur*))
      (progn
	(setf *cur* 1023)
	(setf *acc* 'huja)))))

(write *acc*)
(terpri)
