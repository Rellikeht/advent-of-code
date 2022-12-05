#!/bin/sbcl --script
(load "sol.cl")

(defun good (line)
  (good2 line))

(do ((line (parsed-line) (parsed-line)))
  ((null line))
  (if (good line)
    (setf *count* (+ *count* 1))))

(format t "~A~%" *count*)
