#!/bin/sbcl --script
(load "read.cl")
(load "check.cl")

(defun sum (bads &optional (sum 0))
  (if bads
    (sum (cdr bads) (+ sum (car bads)))
    sum))

(read-syms-list *fields* read-field)
(rl)
(read-ticket)
(rl)
(rl)
(read-syms-list *tickets* read-ticket)

(let
  ((bads (check-tickets *tickets* *fields*)))
  (write (sum bads))
  (terpri))
