#!/bin/sbcl --script
(load "../common.cl")

(declaim
  (optimize (speed 3))
  (fixnum *amount*)
  (fixnum *cur-num*)
  (fixnum *cur-round*))

(defparameter *amount* (rs))
(defparameter *start-nums* (read-comma-nums-nonrev))

(defparameter *nums*
  (make-hash-table
    :test 'eq
    :size (* *amount* 10)
    :rehash-size 3.0
    ))
(defparameter *cur-num* 0)
(defparameter *start-round* 1)

(do ((start-nums *start-nums* (cdr start-nums))
     (cnt *start-round* (+ cnt 1)))
  ((null start-nums)
   (setf *cur-num* 0)
   (defparameter *cur-round* cnt))
  (setf *cur-num* (car start-nums))
  (setf (gethash *cur-num* *nums*) cnt))

(defun update-nums ()
  (let
    ((used (gethash *cur-num* *nums*)))
    (setf (gethash *cur-num* *nums*) *cur-round*)
    (if used
      (setf *cur-num* (- *cur-round* used))
      (setf *cur-num* 0))
    (incf *cur-round*)))

(do () ((>= *cur-round* *amount*))
  (update-nums))

(write (cons *cur-round* *cur-num*))
(terpri)
