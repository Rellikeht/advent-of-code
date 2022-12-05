#!/bin/sbcl --script

(defmacro rl ()
  '(read-line t nil nil))

(defun get-bin (str zero one &optional (num 0))
  (if (string= str "")
    num
    (get-bin
      (subseq str 1)
      zero
      one
      (+ (ash num 1)
	 (if (char= (char str 0) one)
	   1
	   0)))))

(defun decode (line)
  (if (null line)
    '(1023)
    (let*
      ((row (subseq line 0 7))
       (col (subseq line 7 10))
       (rown (get-bin row #\F #\B))
       (coln (get-bin col #\L #\R)))
      (list (+ (ash rown 3) coln)
	    rown
	    coln))))

(do*
  ((line (rl) (rl))
   (dec (decode line)
	(decode line))
   (id (car dec)
       (car dec))
   (pid id))
  ((null line))
  (if (> (- id pid) 1)
    (format t "~A ~A~%" pid id))
  (setf pid id))
