#!/bin/sbcl --script

(defparameter
  *checks*
  '(("byr" . byrc)
    ("iyr" . iyrc)
    ("eyr" . eyrc)
    ("hgt" . hgtc)
    ("hcl" . hclc)
    ("ecl" . eclc)
    ("pid" . pidc)))

(defun byrc (str)
  (let ((y (parse-integer str)))
    (and (>= y 1920) (<= y 2002))))

(defun iyrc (str)
  (let ((y (parse-integer str)))
    (and (>= y 2010) (<= y 2020))))

(defun eyrc (str)
  (let ((y (parse-integer str)))
    (and (>= y 2020) (<= y 2030))))

(defun hgtc (str)
  (let*
    ((isp (split1 str #\i))
     (inum (car isp))
     (csp (split1 str #\c))
     (cnum (car csp)))
    (write isp)
    (write csp)
    (terpri)
    (if
      (null (cadr isp))
      (if
	(null (cadr csp))
	nil
	(let
	  ((num (parse-integer cnum)))
	  (and (>= num 150) (<= num 193))))
      (let
	((num (parse-integer inum)))
	(and (>= num 59) (<= num 76))))))

(defparameter *coll* '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\a #\b #\c #\d #\e #\f))
(defun hclc (str)
  (let*
    ((ssp (split1 str #\#))
     (ss (cadr ssp)))
    (if (null ss)
      nil
      (let
	((ls (length ss)))
	(if (= ls 6)
	  (do* ((i 0 (incf i)))
	    ((>= i ls)
	     t)
	    (if (member-if
		  (lambda (x)
		    (string=
		      (char ss i)
		      x)) *coll*)
	      t
	      (tagbody
		(setf i ls)
		nil)))
	  nil)))))

(defparameter *ecls* '("amb" "blu" "brn" "gry" "grn" "hzl" "oth"))
(defun eclc (str)
  (member-if (lambda (x) (string= x str)) *ecls*))

(defun pidc (str)
  (if (= (length str) 9)
    (every
      (lambda (c)
	(and (char>= c #\0)
	     (char<= c #\9)))
      str)
    nil))

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

(defun good (pass &optional (rest-fields (copy-alist *checks*)))
  (if pass
    (let*
      ((ps (split1 (car pass) #\:))
       (m (assoc-if (lambda (x) (string= (car ps) x)) rest-fields)))
      (if m
	(let
	  ((fc (funcall (cdr m) (cadr ps))))
	  (format t "~A ~A ~A~%" m ps fc)
	(if fc
	  (good
	    (cdr pass)
	    (delete m rest-fields))
	  0))
	(good
	  (cdr pass)
	  rest-fields)))
    (if rest-fields
      0
      1)))

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
