(load "../common.cl")

(defparameter *fields* '())
(defparameter *my-ticket* '())
(defparameter *tickets* '())

(defun parse-field (line &optional (field '()))
  (let*
    ((isp (split line #\:))
     (name (car isp))
     (int-str (subseq (cdr isp) 1))
     (i1 (split int-str #\ ))
     (i2 (cdr (split (cdr i1) #\ )))
     (int1 (split (car i1) #\-))
     (int2 (split i2 #\-))
     (int1n
       (cons
	 (parse-integer (car int1))
	 (parse-integer (cdr int1))))
     (int2n
       (cons
	 (parse-integer (car int2))
	 (parse-integer (cdr int2)))))
    (cons (cons int1n int2n) name)))

(defun read-field (&optional (line (rl)))
  (if (and line (> (length line) 0))
    (parse-field line)
    nil))

(defun parse-ticket (line &optional (ticket '()))
  (if line
    (let*
      ((sp (split line #\,))
       (fst (car sp))
       (rst (cdr sp)))
      (if rst
	(parse-ticket rst (cons (parse-integer fst) ticket))
	(cons (parse-integer fst) ticket)))
    ticket))

(defun read-ticket (&optional (line (rl)))
  (if line
    (parse-ticket line)
    nil))
