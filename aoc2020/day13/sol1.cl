#!/bin/sbcl --script
(load "../common.cl")

(defun next-elem (&optional (ch (rc)) (elem '()))
  (next-comma-elem ch elem))

(defun to-num (lst &optional (num 0))
  (char-list-to-num lst num))

(defun next-num (&optional (elem (next-elem)))
  (if elem
    (if (char= (car elem) #\x)
      (next-num (next-elem))
      (to-num elem))
    nil))

(defun waiting-time (start bus)
  (+ start bus (- (mod start bus))))

(defparameter *start* (rs))
;(defparameter *buses* '())

(do ((num (next-num) (next-num))
     (s (* 2 *start*))
     (bus 0))
  ((null num)
   (write (* bus (- s *start*)))
   (terpri))
  (let
    ((w (waiting-time *start* num)))
    (if (< w s)
      (progn
	(setf s w)
	(setf bus num)))))
