#!/bin/sbcl --script
(load "../common.cl")

(defparameter *mem* (make-hash-table :test 'equal))
(defparameter *sum* 0)

; car - zeros, cdr - ones
(defun get-mask (str &optional (len (length str))
		     (i 0) (zeros 1) (ones 0))
  (if (< i len)
    (let ((ch (char str i))
	  (ni (+ i 1)))
      (if (char= #\0 ch)
	(get-mask str len ni (ash zeros 1) (ash ones 1))
	(if (char= #\1 ch)
	  (get-mask str len ni (+ (ash zeros 1) 1) (+ (ash ones 1) 1))
	  (get-mask str len ni (+ (ash zeros 1) 1) (ash ones 1)))))
    (cons zeros ones)))

(defun get-addr (str &optional
		     (i (- (length str) 1))
		     (m 1)
		     (addr 0))
  (if (>= i 0)
    (let* ((ch (char str i))
	   (dch (digit-char-p ch)))
      (if dch
	(get-addr str (- i 1) (* m 10) (+ addr (* m dch)))
	(get-addr str (- i 1) m addr)))
    addr))

(defun apply-mask (mask val)
  (logior (logand (car mask) val) (cdr mask)))

(do ((sym (rs) (rs))
     (mask ""))
  ((null sym))
  (rs)
  (if (equal 'MASK sym)
    (setf mask (get-mask (symbol-name (rs))))
    (let
      ((addr (get-addr (symbol-name sym)))
       (val (rs)))
      (setf (gethash addr *mem*)
	    (apply-mask mask val)))))

(maphash (lambda (k v) (setf *sum* (+ *sum* v))) *mem*)
(write *sum*)
(terpri)
