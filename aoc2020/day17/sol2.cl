#!/bin/sbcl --script
(load "../common.cl")

(defparameter *steps* 6)
(defparameter *padding* (* 2 (+ 1 *steps*)))
(defparameter *ins* '())

(read-chars-2list *ins*)
(setf *ins*
      (mapcar
	(lambda (l) (mapcar (lambda (e) (if (char= #\# e) 1 0)) l))
	*ins*))

(defparameter *size*
  (list (+ *padding* (length (car *ins*)))
	(+ *padding* (length *ins*))
	(+ *padding* 1) (+ *padding* 1)))

(defparameter *space*
  (make-array *size* :initial-element 0))
(defparameter *new-space*
  (make-array *size* :initial-element 0))

(let
  ((i 0)
   (j 0))
  (dolist (l *ins*)
    (setf j 0)
    (dolist (f l)
      (setf (aref
	      *space* (+ i *steps* 1)
	      (+ j *steps* 1) (+ *steps* 1) (+ *steps* 1)) f)
      (incf j))
    (incf i)))

(defun val-at (x y z w)
  (let
    ((xb (+ x 1))
     (yb (+ y 1))
     (zb (+ z 1))
     (wb (+ w 1))
     (val (- (aref *space* x y z w))))
    (do ((i (- x 1) (+ i 1))) ((> i xb))
      (do ((j (- y 1) (+ j 1))) ((> j yb))
	(do ((k (- z 1) (+ k 1))) ((> k zb))
	  (do ((l (- w 1) (+ l 1))) ((> l wb))
	    (setf val (+ val (aref *space* i j k l)))))))
    val))

(defun eval-step ()
  (let
    ((is (car *size*))
     (js (cadr *size*))
     (ks (caddr *size*))
     (ls (cadddr *size*))
     (tmp *space*))
    (do ((i (- is 2) (- i 1))) ((= i 0))
      (do ((j (- js 2) (- j 1))) ((= j 0))
	(do ((k (- ks 2) (- k 1))) ((= k 0))
	  (do ((l (- ls 2) (- l 1))) ((= l 0))
	    (let
	      ((v (val-at i j k l))
	       (cv (aref *space* i j k l)))
	      (if (zerop cv)
		(if (= v 3)
		  (setf (aref *new-space* i j k l) 1)
		  (setf (aref *new-space* i j k l) 0))
		(if (or (< v 2) (> v 3))
		  (setf (aref *new-space* i j k l) 0)
		  (setf (aref *new-space* i j k l) 1))
		))))))
    (setf *space* *new-space*)
    (setf *new-space* tmp)))

(defun count-active ()
  (let
    ((is (car *size*))
     (js (cadr *size*))
     (ks (caddr *size*))
     (ls (cadddr *size*))
     (cnt 0))
    (do ((i (- is 1) (- i 1))) ((< i 0))
      (do ((j (- js 1) (- j 1))) ((< j 0))
	(do ((k (- ks 1) (- k 1))) ((< k 0))
	  (do ((l (- ls 1) (- l 1))) ((< l 0))
	    (setf cnt (+ cnt (aref *space* i j k l)))))))
    cnt))

(do ((s *steps* (- s 1)))
  ((zerop s))
  (eval-step))

(print (count-active))

(terpri)
