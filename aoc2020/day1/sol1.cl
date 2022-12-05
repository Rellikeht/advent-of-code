#!/bin/sbcl --script
(load "../common.cl")

(defparameter *nums* '())
(read-syms-list *nums*)

(do* ((fi *nums* (cdr fi)) (fie (car *nums*) (car fi))) ((null fi))
	(do* ((si fi (cdr si)) (sie (car si) (car si))) ((null si))
		(if (eq 2020 (+ sie fie))
			(tagbody
				(format t "~A ~A~%" fie sie)
				(setf si '(1))
				(setf fi '(1))))))
;		(format t "~A~%" 'linia))))

