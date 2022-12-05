#!/bin/sbcl --script
(load "../common.cl")

(defparameter *initial-size* 400)
(defparameter *sides* (make-hash-table :size *initial-size*))
(defparameter *image-size* 0)

(defmacro gs (var)
  `(gethash ,var *sides*))

(defmacro upsides (name up down right left)
  `(let
     ((cu (gs up)) (cd (gs down))
      (cr (gs right)) (cl (gs left)))
     (setf (gs up) (cons (cons (cons -1 0) name) cu))
     (setf (gs down) (cons (cons (cons 1 0) name) cd))
     (setf (gs right) (cons (cons (cons 0 1) name) cr))
     (setf (gs left) (cons (cons (cons 0 -1) name) cl))))

;góra - prawo
;prawo - dół
;dół - lewo
;lewo - góra

(defun get-up (line len &optional
		    (c1 0) (c2 0) (ch 0)
		    (c1p (expt 2 (ash len 1))))
  (if (>= ch len)


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
       (up (get-hu fl w))
       (leftl (list (char fl 0)))
       (rightl (list (char fl w))))
      (do ((prevl fl ln)
	   (ln (rl) (rl)))
	((or (null ln) (string= "" ln))
	 (let
	   ((down (get-hd prevl w))
	    (right (get-v (reverse rightl)))
	    (left (get-v leftl)))
	   (upsides name up down right left)
	   (incf *image-size*)
	   t))
	(setf leftl (cons (char ln 0) leftl))
	(setf rightl (cons (char ln w) rightl))
	(incf height)))
    nil))

(do ((tile (next-tile) (next-tile)))
  ((null tile)))

(maphash
  (lambda (k v)
    (print (cons k v)))
  *sides*)

;(defparameter *borders* (make-hash-table :size *initial-size*))
;(maphash
;  (lambda (k v)
;    (if (cdr v)
;      nil
;      (let
;	((name (caar v))
;	 (side (cdar v))
;	 )
;	(setf
;	  (gethash name *borders*)
;	  (cons side (gethash name *borders*)))
;	)
;      )
;    )
;  *sides*)

;(setf *image-size* (* *image-size* 2))
;(defparameter *tiled* (make-hash-table :size *image-size*))

;(maphash (lambda (k v) (print (cons k v))) *borders*)

;(defparameter *mult* 1)
;
;(print *mult*)

(terpri)
