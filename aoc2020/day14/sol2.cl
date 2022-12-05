#!/bin/sbcl --script
(load "../common.cl")

(defparameter *mem* (make-hash-table :test 'equal))
(defparameter *sum* 0)

(defun upm (add masks &optional (new-masks '()))
  (if masks
    (upm add (cdr masks)
	 (append (list (+ (ash (car masks) 1) add)) new-masks))
    new-masks))

(defun perm (masks &optional (new-masks '()))
  (if masks
    (let*
      ((mask (car masks))
       (nm (ash mask 1)))
      (perm
	(cdr masks)
	(append 
	  (list nm)
	  (list (+ nm 1))
	  new-masks)))
    new-masks))

(defun get-mask (str)
  (let*
    ((first-char (char str 0))
     (dig (digit-char-p first-char))
     (len (- (length str) 1)))
  (labels
    ((gm
       (str i or-masks and-masks)
       (if (> i len)
	 (values or-masks and-masks)
	 (let*
	   ((ch (char str i))
	    (dig (digit-char-p ch))
	    (ni (+ i 1)))
	   (if dig
	     (gm str ni
		 (upm dig or-masks)
		 (upm 1 and-masks))
	     (gm str ni
		 (perm or-masks)
		 (perm and-masks)))
	   ))))
    (if (char= #\X first-char)
      (gm str 1 '(0 1) '(0 1))
      (gm str 1
	  (cons (if (char= #\1 first-char) 1 0) nil)
	  (cons (if (char= #\0 first-char) 0 1) nil))))))

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

(defun write-mem (addr or-masks and-masks val)
  (if or-masks
    (let
      ((orm (car or-masks))
       (andm (car and-masks))
       (or-rest (cdr or-masks))
       (and-rest (cdr and-masks)))
      (setf (gethash (logand (logior addr orm) andm) *mem*) val)
      (write-mem addr or-rest and-rest val))
    t))

(do ((sym (rs) (rs))
     (or-masks '())
     (and-masks '()))
  ((null sym))
  (rs)
  (if (equal 'MASK sym)
    (multiple-value-setq
      (or-masks and-masks)
      (get-mask (symbol-name (rs))))
    (let
      ((addr (get-addr (symbol-name sym)))
       (val (rs)))
      (write-mem addr or-masks and-masks val))))

;(maphash (lambda (k v) (write (cons k v)) (terpri)) *mem*)

(maphash (lambda (k v) (setf *sum* (+ *sum* v))) *mem*)
(write *sum*)
(terpri)
