#!/bin/sbcl --script

(defun get-next-ch (i)
  (let*
      ((line (read-line t nil nil))
       (ll (length line)))
    (if (null line)
	#\q
	(char line (mod i ll)))))

(do*
    ((i 0 (+ i 3))
     (nc (get-next-ch i) (get-next-ch i))
     (cnt 0
	  (+ cnt
	     (if (char= nc #\#)
		 1
		 0))))
    ((char= nc #\q)
     (write cnt)
     (terpri))
  ())
