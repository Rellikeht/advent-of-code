#!/bin/sbcl --script
(load "../common.cl")

(defun next-elem (&optional (ch (rc)) (elem '()))
  (next-comma-elem ch elem))

(defun to-num (lst &optional (num 0))
  (char-list-to-num lst num))

(defun next-bus (&optional (elem (next-elem)))
  (if elem
    (if (digit-char-p (car elem))
      (to-num elem)
      elem)
    elem))

(defparameter *buses* '())
(rs)
;(write (list 'first (rs)))
;(terpri)

(do ((bus (next-bus) (next-bus)))
  ((null bus))
   (setf *buses* (append *buses* (list bus))))

(defparameter *bus-len* (length *buses*))
(defparameter *emp* (count '(#\x) *buses* :test 'equal))
(setf *bus-len* (- *bus-len* *emp*))
(defparameter *bus-arr* (make-array *bus-len*))

(do ((bs *buses* (cdr bs))
     (i 0 (+ i 1))
     (j 0)
     (p 0))
  ((null bs))
  (let
    ((bid (car bs)))
    (if (numberp bid)
      (progn
	(setf (aref *bus-arr* j) (cons (car bs) (+ i (- p))))
	(setf p i)
	(incf j)))))

(defun find-time-buses (cur-time delay bus1 bus2)
  (if (= (mod (+ cur-time delay) bus2) 0)
    (cons cur-time (lcm bus1 bus2))
    (find-time-buses (+ cur-time bus1) delay bus1 bus2)))

(write
(do* ((bus1i 1 (+ bus1i 1))
      (bus0 (car (aref *bus-arr* 0)))
      (bus1d (aref *bus-arr* bus1i))
      (moment bus0)
      (delay 0))
  ((>= bus1i *bus-len*)
   moment)
  (let*
    ((bus1d (aref *bus-arr* bus1i))
     (bus1 (car bus1d))
     (m (find-time-buses moment
			 (setf delay (+ delay (cdr bus1d)))
			 bus0 bus1)))
;    (write (list bus0 (car bus1d) moment delay))
;    (terpri)
    (setf bus0 (cdr m))
    (setf moment (car m)))
))
(terpri)
