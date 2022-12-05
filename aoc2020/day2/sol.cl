(load "../common.cl")

(defparameter *count* 0)

(defun line-tokens ()
  (let
    ((line (read-line t nil nil)))
    (if (null line)
      '(nil nil nil)
      (let*
	((t1 (split line #\ ))
	 (t2 (split (cdr t1) #\ ))
	 (t3 (cdr t2)))
	(values (car t1)
		(car t2)
		t3)))))

(defun parse-nums (str)
  (cons (parse-integer (car str))
	(parse-integer (cdr str))))

(defun parsed-line ()
  (multiple-value-bind
    (p1 p2 p3)
    (line-tokens)
    (if (or (null p1) (null p2) (null p3))
      nil
      (list
	(parse-nums (split p1 #\-))
	(char p2 0)
	p3))))

(defun good1 (line)
  (let*
    ((ch (cadr line))
     (str (caddr line))
     (cnt (count ch str))
     (most (cdar line))
     (least (caar line)))
    (if (and (<= cnt most) (>= cnt least))
      t
      nil)))

(defun good2 (line)
  (let*
    ((ch (cadr line))
     (str (caddr line))
     (fst (- (caar line) 1))
     (snd (- (cdar line) 1))
     (len (length str)))
    (if (char= (char str fst) ch)
      t
      nil)
    (if (char= (char str fst) ch)
      (if (char= (char str snd) ch)
	nil
	t)
      (if (char= (char str snd) ch)
	t
	nil))))
