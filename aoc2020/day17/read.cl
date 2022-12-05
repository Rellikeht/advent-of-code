(load "../common.cl")

(defun pop-line (sp line xpos ypos zpos &optional (len (length line)) (ch 0))
  (if (< ch len)
    (progn
      (setf (aref sp xpos ypos zpos)
	    (char line ch))
      (pop-line sp line (+ xpos 1) ypos zpos len (+ ch 1)))
    t))

(defun populate (sp lines xstart ypos zstart)
  (if lines
    (let
      ((line (car lines))
       (rst (cdr lines)))
      (pop-line sp line xstart ypos zstart (length line))
      (populate sp rst xstart (+ ypos 1) zstart))
    t))

(defmacro read-space (spc steps)
  `(do* ((line (rl) (rl))
	 (lines '())
	 (len (length line))
	 (padding (* 2 ,steps)))
     ((null line)
      (let
	((size (list
		 (+ padding len)
		 (+ padding (length lines))
		 (+ padding 1))))
	(setf ,spc
	      (make-array size :initial-element #\.))
	(populate ,spc lines ,steps ,steps ,steps)
	size))
     (setf lines (append lines (cons line '())))))
