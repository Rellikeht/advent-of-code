#!/bin/sbcl --script

;(defparameter *fields* '("byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid" "cid"))
(defparameter *fields* '("byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"))

(defmacro rl ()
  '(let
     ((ln (read-line t nil nil)))
     (if (or (null ln)
	     (string= ln ""))
       nil
       ln)))

(defun split1 (str delim)
  (let
    ((sl (length str)))
    (labels
      ((spl (str del in)
	    (if (>= in sl)
	      `(,str nil)
	      (if (char= (char str in) del)
		`(,(subseq str 0 in) ,(subseq str (incf in)))
		(spl str del (+ in 1))))))
      (spl str delim 0))))

(defun split (str delim &optional (cur-sp '()))
  (if (null str)
    cur-sp
    (let
      ((sp (split1 str delim)))
      (split (cadr sp)
	     delim
	     (append cur-sp `(,(car sp)))))))

(defun get-next-lines ()
  (let
     ((fline (rl)))
     (if (null fline)
       nil
       (do* ((nline (rl) (rl))
	     (lines `(,fline ,nline)
		    (append lines `(,nline))))
	 ((null nline)
	  lines)))))

(defun get-next-pass (lines &optional (passf '()))
  (if (null lines)
    passf
    (get-next-pass
      (cdr lines)
      (append passf
	      (split (car lines) #\ )))))

(defun good (pass &optional (rest-fields *fields*))
  (if (null rest-fields)
    1
    (if (null pass)
      0
      (good
	(cdr pass)
	(check
	  (car
	    (split1
	      (car pass)
	      #\:))
	  rest-fields)))))

(defun check (str fields &optional (rest-fields '()))
  (if (null fields)
    rest-fields
    (let
      ((ff (car fields))
       (rf (cdr fields)))
      (if
	(string= str ff)
	(append rf rest-fields)
	(check
	  str
	  rf
	  (append rest-fields `(,ff)))))))

(do*
  ((ls (get-next-lines)
       (get-next-lines))
   (pass (get-next-pass ls)
	 (get-next-pass ls))
   (cnt (good pass)
	(+ cnt (good pass))))
  ((null ls)
   (write cnt)
   (terpri)))
