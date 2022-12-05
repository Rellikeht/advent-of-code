#!/bin/sbcl --script

(defmacro rl ()
  '(read-line t nil nil))

(defmacro rc ()
  '(read-char t nil nil))

(defun next-group ()
  (let
    ((answers '())
     (bc #\ ))
    (do* ((c (rc) (rc)))
      ((or
	 (null c)
	 (char= bc c))
       answers)
      (if (not (member c answers))
	(if (not (char= c #\Newline))
	  (setf answers (cons c answers))))
      (setf bc c))))

(defparameter *cnt* 0)
(do ((group (next-group) (next-group)))
  ((null group))
  (setf *cnt* (+ *cnt* (length group))))
(write *cnt*)
(terpri)
