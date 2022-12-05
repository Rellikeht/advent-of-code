#!/bin/sbcl --script

(defmacro rs ()
  '(read t nil nil))

(defparameter *line-end* '(bag. bags.))
(defparameter *elem-end* '(bag bags))
(defparameter *cont* '(contain))
(defparameter *elem-sep* '(q))
(defparameter *separators*
  (append
    *elem-end*
    *cont*
    *elem-sep*
    *line-end*))

(defparameter *rules* '())

(defmacro is-sep (sym)
  `(if (member ,sym *separators*)
    '()
    ,sym))

(defun get-bag (&optional (bag '()) (sym (rs)))
  (if sym
    (if (member sym *line-end*)
      (values bag t)
      (if (or (member sym *separators*)
	      (numberp sym))
	(if bag
	  (values bag nil)
	  (get-bag bag (rs)))
	(get-bag (append
		   bag
		   (cons sym '()))
		 (rs))))
    (if bag
      (values bag t)
      (values nil t))))

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
(defparameter *containing* '())

(do* ((rule (get-rule) (get-rule)))
  ((null rule))
  (setf *rules* (cons rule *rules*)))

(defun is-in (elems containing)
  (if elems
    (if (member (car elems) containing :test 'equal)
      t
      (is-in (cdr elems) containing))
    nil))

(defun update-containing (rules containing &optional (new-rules '()))
  (if rules
    (let*
      ((rule (car rules))
       (elem (car rule))
       (elems (cdr rule)))
      (if (or (member *main-bag* elems :test 'equal)
	      (is-in elems containing))
	(update-containing
	  (cdr rules)
	  (append containing (list elem))
	  new-rules)
	(update-containing
	  (cdr rules)
	  containing
	  (append new-rules (list rule)))))
    (values containing new-rules)))

(defun constant-update (rules containing)
  (let
    ((cl (length containing)))
    (write cl)
    (terpri)
    (multiple-value-bind
      (newc newr)
      (update-containing rules containing)
      (let
	((newcl (length newc)))
	(if (= newcl cl)
	  (values cl newc)
	  (constant-update newr newc))))))

(write (constant-update *rules* *containing*))
(terpri)
