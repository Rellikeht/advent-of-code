#!/bin/sbcl --script

(defmacro rs ()
  '(read t nil nil))

(defparameter *line-end* '(bag. bags.))
(defparameter *elem-end* '(bag bags))

(defparameter *rules* '())

(defun get-bag (&optional (bag '()) (sym (rs)) (cnt 1))
  (if sym
    (if (member sym *line-end*)
      (values (cons bag cnt) t)
      (if (member sym *elem-end*)
	(values (cons bag cnt)nil)
	(if (numberp sym)
	  (get-bag bag (rs) sym)
	  (get-bag
	    (append
	      bag
	      (list sym))
	    (rs) cnt))))
    nil))

(defun update-rule (rule bag)
  (let
    ((rr (cdr rule))
     (fr (car rule)))
    (if rr
      (cons fr (append rr (cons bag '())))
      (cons fr (cons bag '())))))

(defun get-rule (&optional (rule (cons (get-bag) '())))
  (if (car rule)
    (multiple-value-bind
      (bag end)
      (get-bag)
      (if end
	(update-rule rule bag)
	(get-rule (update-rule rule bag))))
    nil))

(defparameter *main-bag* '(shiny gold))
;(defparameter *containing* '())
(defparameter *reduced* '())

(do* ((rule (get-rule) (get-rule)))
  ((null rule))
  (setf *rules* (cons rule *rules*)))

(defmacro chcar (e1 e2)
  (list 'equal
	e1
	(list 'car e2)))

(defun reduce-other (rules &optional (new-rules '()) (reduced '()))
  (if rules
    (let*
      ((rule (car rules))
       (fst (car rule))
       (rst (cdr rule)))
;      (format t "~A : ~A~%" fst rst) 
      (if (equal rst '(((no other) . 1)))
	(reduce-other
	  (cdr rules)
	  new-rules
	  (append (list fst) reduced))
	(reduce-other
	  (cdr rules)
	  (append (list rule) new-rules)
	  reduced)))
    (values new-rules reduced)))

(defun reduce-empty (rules
		      reduced
		      &optional
		      (new-rules '())
		      (new-reduced '()))
  (if rules
      (values
	new-rules
	(append reduced new-reduced))))

(multiple-value-bind
  (n r)
    (reduce-other *rules*)
  (write n)
  (terpri)
  (terpri)
  (write r)
  (terpri))
