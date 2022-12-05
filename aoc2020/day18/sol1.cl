#!/bin/sbcl --script
(load "../common.cl")

(defparameter *exprs* '())
(read-lines-list *exprs*)

(defparameter *ops* (make-hash-table :size 2 :test 'equal))
(setf (gethash "+" *ops*) '+)
(setf (gethash "*" *ops*) '*)

(defun parse-flat-v (expr &optional (val 0))
  (if (and expr (string/= expr ""))
    (let*
      ((opc (split expr #\ ))
       (op (gethash (car opc) *ops*))
       (numc (split (cdr opc) #\ ))
       (num (parse-integer (car numc)))
       (nexpr (cdr numc)))
      (parse-flat-v
	nexpr (funcall op val num)))
    val))

(defun parse-flat (expr)
  (let
    ((sp (split expr #\ )))
    (parse-flat-v (cdr sp) (parse-integer (car sp)))))

(defun evaluate (expr &optional (ch 0) (len (length expr)))
  (if (< ch len)
    (let
      ((cch (char expr ch)))
      (if (char= cch #\()
	(let*
	  ((bp (subseq expr 0 ch))
	   (ap (subseq expr (+ ch 1))))
	  (evaluate
	    (concatenate 'string bp (evaluate ap))))
	(if (char= cch #\))
	  (let*
	    ((bp (subseq expr 0 ch))
	     (ap (subseq expr (+ ch 1))))
	    (concatenate
	      'string (write-to-string (parse-flat bp)) ap))
	  (evaluate expr (+ ch 1) len))))
    (parse-flat expr)))

(do ((exprs *exprs* (cdr exprs))
     (results '()))
  ((null exprs)
   (print (reduce '+ results)))
  (append! results (evaluate (car exprs))))
(terpri)
