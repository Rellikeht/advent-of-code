(defun check-interval (val int)
  (let*
    ((i1 (car int))
     (i2 (cdr int))
     (i1l (car i1))
     (i1h (cdr i1))
     (i2l (car i2))
     (i2h (cdr i2)))
    (if (or (and (>= val i1l) (<= val i1h))
	    (and (>= val i2l) (<= val i2h)))
      val
      nil)))

(defun check-val (val rules &optional (res nil))
  (if rules
    (let*
      ((rule (car rules))
       (int (car rule))
       (rst (cdr rules))
       (vval (check-interval val int)))
      (if vval
	nil
	(check-val val rst val)))
    val))

(defun check-ticket (ticket rules &optional (bads '()))
  (if ticket
    (let*
      ((val (car ticket))
       (rst (cdr ticket))
       (vval (check-val val rules)))
      (if vval
	(check-ticket rst rules (cons vval bads))
	(check-ticket rst rules bads)))
    bads))

;; Part 1
(defun check-tickets (tickets rules &optional (bads '()))
  (if tickets
    (check-tickets
      (cdr tickets) rules
      (append (check-ticket (car tickets) rules) bads))
    bads))

;; Part 2
(defun good-tickets (tickets rules &optional (good '()))
  (if tickets
    (let
      ((ticket (car tickets)))
      (good-tickets
	(cdr tickets) rules
	(if (check-ticket ticket rules)
	  good
	  (cons ticket good))))
    good))

(defun find-fields (val fields &optional (match '()))
  (if fields
    (let*
      ((field (car fields))
       (rule (car field))
       (rst (cdr fields)))
      (if (check-interval val rule)
	(find-fields
	  val rst
	  (append match (list field)))
	(find-fields val rst match)))
    match))

(defun update-matches (vals matches &optional (i 0))
  (if vals
    (let*
      ((cur-matches (aref matches i))
       (matl (length cur-matches))
       (val (car vals))
       (rst (cdr vals))
       (ni (+ i 1)))
      (if (= matl 1)
	(update-matches rst matches ni)
	(let
	  ((new-matches (find-fields val cur-matches)))
	  (setf (aref matches i) new-matches)
	  (update-matches rst matches ni))))
    t))
