#!/bin/sbcl --script

(defparameter *lines* '())

(defmacro rl ()
  '(read-line t nil nil))

(do ((line (rl) (rl)))
    ((null line))
  (setf *lines*
	(append *lines* `(,line))))

(let
    ((lines *lines*)
     (mult 1))

  (defun next-line ()
    (let
	((cl (car lines))
	 (nl (cdr lines)))
      (setf lines nl)
      cl))

  (defun get-next-ch (i nl)
    (do ((l 1 (incf l)))
	((>= l nl))
      (next-line))
    (let*
	((line (next-line))
	 (ll (length line)))
      (if (null line)
	  #\q
	  (char line (mod i ll)))))

  (defun count-slope (slx sly)
;    (next-line)
    (do*
	((i 0 (+ i slx))
	 (nc (get-next-ch i sly) (get-next-ch i sly))
	 (cnt 0
	      (+ cnt
		 (if (char= nc #\#)
		     1
		     0))))
	((char= nc #\q)
	 (write cnt)
	 (terpri)
	 (setf mult (* mult cnt))
	 (setf lines *lines*))
      ()))

  (defun get-mult ()
    mult))

(count-slope 1 1)
(count-slope 3 1)
(count-slope 5 1)
(count-slope 7 1)
(count-slope 1 2)
(write (get-mult))
(terpri)
