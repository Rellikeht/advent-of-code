(defmacro rs ()
  '(read t nil nil))

(defmacro rl ()
  '(read-line t nil nil))

(defmacro rc ()
  '(read-char t nil nil))

(defmacro append! (var elem)
  (list 'setf var
	(list 'append var
	      (list 'list elem))))

(defun split (str delim &optional (ch 0) (len (length str)))
  (if (< ch len)
    (if (char= (char str ch) delim)
      (cons (subseq str 0 ch)
	    (subseq str (+ ch 1)))
      (split str delim (+ ch 1) len))
    (cons str nil)))

(defun bsplit (str delim &optional (ch (- (length str) 1)))
  (if (<= ch 0)
    (cons nil str)
    (if (char= (char str ch) delim)
      (cons (subseq str 0 ch)
	    (subseq str (+ ch 1)))
      (bsplit str delim (- ch 1)))))

(defmacro read-syms-list (var &optional (rf 'rs))
  (list 'do `((sym (,rf) (,rf)))
	'((null sym))
	(list 'append! var 'sym)))

(defmacro read-lines-list (var)
  (list 'read-syms-list var 'rl))

(defun line-chars (line len &optional (chars '()))
  (if (< len 0)
    chars
    (line-chars line (- len 1)
		(cons (char line len) chars))))

(defmacro read-chars-2list (var)
  (list 'do
	`((line (rl) (rl)))
	'((null line))
	(list 'append! var
	      '(line-chars
		 line
		 (- (length line) 1)))))

(defun cp-row! (var line num &optional
		    (cstart 0)
		    (ch (- (length line) 1)))
  (if (< ch 0)
    (+ (length line) cstart -1)
    (progn
      (setf (aref var num (+ ch cstart))
	    (char line ch))
      (cp-row! var line num cstart (- ch 1)))))

(defmacro read-chars-arr (var &optional (rstart 0) (cstart 0))
  (list 'do
	`((line (rl) (rl))
	  (cnt ,rstart (+ cnt 1))
	  (rowl 0))
	`((null line)
	  (list
	    (+ cnt ,rstart -1)
	    (+ rowl ,cstart)))
	`(let
	   ((nrowl (cp-row! ,var line cnt ,cstart)))
	   (if (> nrowl rowl)
	     (setf rowl nrowl)))))

(defun print-arr (arr rowstart rowend colstart colend
		      &optional (row rowstart) (col colstart))
  (if (>= row rowend)
    t
    (if (>= col colend)
      (progn
	(terpri)
	(print-arr arr rowstart rowend colstart colend
		   (+ row 1) colstart))
      (progn
	(princ (aref arr row col))
	(print-arr arr rowstart rowend colstart colend
		   row (+ col 1))))))

(defun char-list-to-num (lst &optional (num 0))
  (if lst
    (char-list-to-num (cdr lst)
	    (+ (* num 10)
	       (digit-char-p (car lst))))
    num))

(defun next-comma-elem (&optional (ch (rc)) (elem '()))
  (if ch
    (if (char= ch #\Newline)
      elem
      (if (char= ch #\,)
	elem
	(next-comma-elem (rc) (append elem (list ch)))))
    elem))

(defun read-comma-separated ()
  (do* ((elem (next-comma-elem)
	      (next-comma-elem))
	(elems (list elem)
	       (append (list elem) elems)))
    ((null elem)
     (cdr elems))))

(defun read-comma-separated-nonrev ()
  (do* ((elem (next-comma-elem)
	      (next-comma-elem))
	(elems))
    ((null elem)
     elems)
    (setf elems (append elems (list elem)))))

(defun read-comma-nums ()
  (mapcar 'char-list-to-num (read-comma-separated)))

(defun read-comma-nums-nonrev ()
  (mapcar 'char-list-to-num (read-comma-separated-nonrev)))
