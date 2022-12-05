#!/bin/sbcl --script
(load "../common.cl")

(defparameter *exprs* '())
(read-lines-list *exprs*)

(defparameter *ops*
  (list
    (make-hash-table :size 1 :test 'equal)
    (make-hash-table :size 1 :test 'equal)))
(setf (gethash "+" (car *ops*)) '+)
(setf (gethash "*" (cadr *ops*)) '*)

(defun parse-level (expr ops val &optional (levup ""))
  (if (and expr (string/= "" expr))
    (let*
      ((opa (split expr #\ ))
       (opc (car opa))
       (opr (cdr opa))
       (op (gethash opc ops))
       (nsp (split opr #\ ))
       (nnum (car nsp))
       (nval (parse-integer nnum))
       (nexpr (cdr nsp)))
      (if op
	(let
	  ((res (funcall op nval val)))
	  (parse-level nexpr ops res levup))
	(let*
	  ((nrst
	     (concatenate
	       'string levup (write-to-string val) " " opc " ")))
	  (parse-level nexpr ops nval nrst))))
    (concatenate 'string levup (write-to-string val))))

(defun parse-flat (expr &optional (ops *ops*))
  (if ops
    (let*
      ((opd (car ops))
       (opr (cdr ops))
       (ss (split expr #\ ))
       (sval (parse-integer (car ss)))
       (sexpr (cdr ss))
       (levup (parse-level sexpr opd sval)))
      (parse-flat levup opr))
    (parse-integer expr)))

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
;   (print results))
   (print (reduce '+ results)))
  (append! results (evaluate (car exprs))))

(terpri)
