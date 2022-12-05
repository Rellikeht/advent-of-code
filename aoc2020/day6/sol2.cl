#!/bin/sbcl --script

(defmacro rl ()
  '(read-line t nil nil))

(defmacro rc ()
  '(read-char t nil nil))

(defun get-group (line &optional (group '()))
  (if (string= line "")
    group
    (get-group
      (subseq line 1)
      (cons (char line 0) group))))

(defun intersect (l1 l2 &optional (int '()))
  (if (or (null l1)
	  (null l2))
    int
    (let*
      ((mem (member (car l1) l2))
       (cm (car mem)))
      (intersect
	(cdr l1)
	(remove cm l2)
	(if (null cm)
	  int
	  (cons cm int))))))

(defun next-group ()
  (let
    ((sl (rl)))
    (if sl
      (do*
	((nl sl (rl))
	 (group (get-group nl)))
	((or
	   (string= "" nl)
	   (null nl))
	 (length group))
	(setf group (intersect
		      group
		      (get-group nl))))
      nil)))

(defparameter *cnt* 0)
(do ((groupl (next-group) (next-group)))
  ((null groupl))
  (setf *cnt* (+ *cnt* groupl)))
(write *cnt*)
(terpri)
