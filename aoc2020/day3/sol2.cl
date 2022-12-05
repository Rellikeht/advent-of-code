#!/bin/sbcl --script
(load "../common.cl")

(defparameter *lines* '())
(read-syms-list *lines* rl)

(defun check-tree (line chn)
  (let*
    ((ll (length line))
     (chi (mod chn ll))
     (ch (char line chi)))
    (if (char= ch #\#)
      1
      0)))

(defun next-step (lines sly)
  (if lines
    (if (zerop sly)
      lines
      (next-step
	(cdr lines)
	(- sly 1)))
    nil))

(defun count-trees (lines slx sly
			  &optional
			  (cnt 0)
			  (cur-char 0))
  (let*
    ((newl (next-step lines sly))
     (line (car newl))
     (rst (cdr newl))
     (nch (+ cur-char slx)))
    (if newl
      (count-trees
	newl slx sly
	(+ cnt (check-tree line nch))
	nch)
      cnt)))

(defparameter sls '((1 . 1) (3 . 1) (5 . 1) (7 . 1) (1 . 2)))

(write
  (do*
    ((nsl sls (cdr nsl))
     (mult 1))
    ((null nsl)
     mult)
    (let
      ((n
	 (count-trees
	   *lines*
	   (caar nsl)
	   (cdar nsl))))
      (setf mult (* mult n)))))
;      (write n)
;      (terpri))))
(terpri)
