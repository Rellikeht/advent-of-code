#!/bin/sbcl --script
(load "../common.cl")

(defparameter *map-row-start* 1)
(defparameter *map-col-start* 1)
(defparameter *map* (make-array '(100 100) :initial-element nil))
(defparameter *size* (read-chars-arr *map*
				     *map-row-start*
				     *map-col-start*))

(defparameter *floor* #\.)
(defparameter *free* #\L)
(defparameter *occupied* #\#)
(defparameter *new-map* (make-array '(100 100) :initial-element nil))

(defun count-occ (fields row chn &optional (cr (+ row 2)) (cch (+ chn 2)) (cnt 0))
  (if (< cr row)
    cnt
    (if (< cch chn)
      (count-occ fields row chn (- cr 1) (+ chn 2) cnt)
      (let
	((ch (aref fields cr cch)))
	(count-occ fields row chn cr (- cch 1)
		 (if ch
		   (if (char= ch *occupied*)
		     (if (or (/= (+ 1 row) cr) (/= (+ 1 chn) cch))
		       (+ cnt 1)
		       cnt)
		     cnt)
		   cnt))))))

(defun update-field (fields new-fields row chn ch)
  (if (char= ch *floor*)
    (progn
      (setf (aref new-fields row chn) *floor*)
      nil)
    (let ((occ (count-occ fields (- row 1) (- chn 1))))
      (if (char= ch *free*)
	(if (= occ 0)
	  (progn
	    (setf (aref new-fields row chn) *occupied*)
	    t)
	  (progn
	    (setf (aref new-fields row chn) *free*)
	    nil))
	(if (> occ 3)
	  (progn
	    (setf (aref new-fields row chn) *free*)
	    t)
	  (progn
	    (setf (aref new-fields row chn) *occupied*)
	    nil))))))

(defun update-row (fields new-fields row &optional
			  (chn *map-col-start*)
			  (changed nil))
  (let ((ch (aref fields row chn)))
    (if ch
      (update-row fields new-fields row (+ chn 1)
	(or (update-field fields new-fields row chn ch) changed))
      changed)))

(defun next-step (fields new-fields &optional
			 (maxr (car *size*))
			 (row *map-row-start*)
			 (changed nil))
  (if (> row maxr)
    changed
    (next-step fields new-fields maxr (+ row 1)
	       (or (update-row fields new-fields row) changed))))

(defmacro print-map (&optional (mp *map*))
  `(print-arr ,mp
	      *map-row-start* (car *size*)
	      *map-col-start* (cadr *size*)))

(defun update-map ()
  (let
    ((ch (next-step *map* *new-map*)))
    (if ch
      (let
	((tmp *map*))
	(setf *map* *new-map*)
	(setf *new-map* tmp)))
    ch))

(do ((ch (update-map)
	 (update-map)))
  ((not ch)))

(defun count-line (fields row start end &optional (cnt 0))
  (if (< end start)
    cnt
    (count-line
      fields row start (- end 1)
      (let
	((ch (aref fields row end)))
	(if (and ch (char= *occupied* ch))
	  (+ cnt 1)
	  cnt)))))

(defun count-lines (fields start end &optional (cnt 0))
  (if (< end start)
    cnt
    (count-lines
      fields start (- end 1)
      (+ cnt (count-line
	       fields end
	       *map-col-start*
	       (cadr *size*))))))

(write (count-lines *map* *map-row-start* (car *size*)))
(terpri)
