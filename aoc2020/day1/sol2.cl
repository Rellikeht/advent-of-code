#!/bin/sbcl --script
(load "../common.cl")

(defparameter *nums* '())
(read-syms-list *nums*)

(setf *nums* (sort *nums* '<))

(do*
  ((fi *nums* (cdr fi))
   (fie (car *nums*) (car fi)))
  ((null fi))
  (do*
    ((si fi (cdr si))
     (sie (car si) (car si)))
    ((null si))
    (do*
      ((ii si (cdr ii))
       (iie (car fi) (car ii)))
      ((null ii))
      (if (eq 2020 (+ sie fie iie))
	(tagbody
	  (format t "~A ~A ~A ~A~%" fie sie iie (* fie sie iie))
	  (setf si '(1))
	  (setf fi '(1)))
	       ))))

