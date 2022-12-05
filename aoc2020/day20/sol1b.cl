#!/bin/sbcl --script
(load "../common.cl")

(defparameter *initial-size* 200)
(defparameter *sidesl* (make-hash-table :size *initial-size*))
(defparameter *sidesr* (make-hash-table :size *initial-size*))
(defparameter *image-size* 0)

(defmacro gs (sides var)
  `(gethash ,var ,sides))

(defmacro upsides (name up down right left sides)
  `(let
     ((cu (gs ,sides up)) (cd (gs ,sides down))
      (cr (gs ,sides right)) (cl (gs ,sides left)))
     (setf (gs ,sides up) (cons (cons (cons -1 0) name) cu))
     (setf (gs ,sides down) (cons (cons (cons 1 0) name) cd))
     (setf (gs ,sides right) (cons (cons (cons 0 1) name) cr))
     (setf (gs ,sides left) (cons (cons (cons 0 -1) name) cl))))

(defun get-hr (line start &optional (code 0))
  (if (< start 0)
    code
    (get-hr
      line (- start 1)
      (+ (ash code 1)
	 (if (char= (char line start) #\#) 1 0)))))

(defun get-hl (line end &optional (code 0) (ch 0))
  (if (> ch end)
    code
    (get-hl
      line end
      (+ (ash code 1)
	 (if (char= (char line ch) #\#) 1 0))
      (+ ch 1))))

(defun get-v (lst &optional (code 0))
  (if lst
    (get-v
      (cdr lst)
      (+ (ash code 1)
	 (if (char= (car lst) #\#) 1 0)))
    code))

(defun next-tile (&optional (ln (rl)))
  (if ln
    (let*
      ((ns (split ln #\ ))
       (names (car (split (cdr ns) #\:)))
       (name (parse-integer names))
       (fl (rl))
       (width (length fl))
       (w (- width 1))
       (height 1)
       (upl (get-hl fl w))
       (upr (get-hr fl w))
       (leftc (list (char fl 0)))
       (rightc (list (char fl w))))
      (do ((prevl fl ln)
	   (ln (rl) (rl)))
	((or (null ln) (string= "" ln))
	 (let
	   ((downl (get-hl prevl w))
	    (downr (get-hr prevl w))
	    (rightr (get-v rightc))
	    (leftr (get-v (reverse leftc)))
	    (rightl (get-v (reverse rightc)))
	    (leftl (get-v leftc)))
	   (upsides name upl downl rightl leftl *sidesl*)
	   (upsides name upr downr rightr leftr *sidesr*)
	   (incf *image-size*)
	   t))
	(setf leftc (cons (char ln 0) leftc))
	(setf rightc (cons (char ln w) rightc))
	(incf height)))
    nil))

(do ((tile (next-tile) (next-tile)))
  ((null tile)))

(maphash
  (lambda (k v)
    (print (cons k v)))
  *sidesr*)

(maphash
  (lambda (k v)
    (print (cons k v)))
  *sidesl*)

;(defparameter *mult* 1)
;
;(print *mult*)

(terpri)
