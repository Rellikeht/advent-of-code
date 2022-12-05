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

(defmacro up-pos (upx upy)
  (list
    'setf '*position*
    (list 'cons
	  (list '+ (list 'car '*position*) upx)
	  (list '+ (list 'cdr '*position*) upy))))

(defun move-rot (amount)
  (cond
    ((= *rotation* 0) (up-pos amount 0))
    ((= *rotation* 90) (up-pos 0 amount))
    ((= *rotation* 180) (up-pos (- amount) 0))
    ((= *rotation* 270) (up-pos 0 (- amount)))))

(defun move (in am)
  (cond
    ((char= in #\N) (up-pos 0 (- am)))
    ((char= in #\E) (up-pos am 0))
    ((char= in #\S) (up-pos 0 am))
    ((char= in #\W) (up-pos (- am) 0))
    (t nil)))

(defun update-vals (instr)
  (let
    ((in (car instr))
     (am (cdr instr)))
    (cond
      ((char= in #\R) (setf *rotation* (mod (+ *rotation* am) 360)))
      ((char= in #\L) (setf *rotation* (mod (- *rotation* am) 360)))
      ((char= in #\F) (move-rot am))
      (t (move in am)))))

(do ((instr (read-instruction) (read-instruction)))
  ((null instr)
   (write *position*)
   (terpri))
  (update-vals instr))
