#!/bin/sbcl --script
(load "../common.cl")

(defun read-instruction ()
  (let
    ((ch (rc))
     (num (rs)))
    (if ch
      (cons ch num)
      nil)))

(defparameter *position* (cons 0 0))
(defparameter *rotation* 0)
(defparameter *waypoint* (cons 10 -1))

(defmacro up-point (pnt upx upy)
  (list
    'setf pnt
    (list 'cons
	  (list '+ (list 'car pnt) upx)
	  (list '+ (list 'cdr pnt) upy))))

(defun mult-point (pnt m)
  (cons
    (* m (car pnt))
    (* m (cdr pnt))))

(defun move (in am)
  (cond
    ((char= in #\N) (up-point *waypoint* 0 (- am)))
    ((char= in #\E) (up-point *waypoint* am 0))
    ((char= in #\S) (up-point *waypoint* 0 am))
    ((char= in #\W) (up-point *waypoint* (- am) 0))
    (t nil)))

(defun move-waypoint (m)
  (let
    ((up (mult-point *waypoint* m)))
    (up-point *position* (car up) (cdr up))))

(defun rotate (am)
  (cond
    ((= am 90) (setf *waypoint* (cons (- (cdr *waypoint*))
				      (car *waypoint*))))
    ((= am 180) (setf *waypoint* (cons (- (car *waypoint*))
				       (- (cdr *waypoint*)))))
    ((= am 270) (setf *waypoint* (cons (cdr *waypoint*)
				       (- (car *waypoint*)))))))

(defun update-vals (instr)
  (let
    ((in (car instr))
     (am (cdr instr)))
    (cond
      ((char= in #\R) (rotate am))
      ((char= in #\L) (rotate (- 360 am)))
      ((char= in #\F) (move-waypoint am))
      (t (move in am)))))

(defun dist (pnt)
  (+ (abs (car pnt)) (abs (cdr pnt))))

(do ((instr (read-instruction) (read-instruction)))
  ((null instr)
   (write *position*)
   (terpri)
   (write (dist *position*))
   (terpri))
  (update-vals instr))
