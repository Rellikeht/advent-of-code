(defmacro charv (ch)
  `(if (char= ,ch #\#) 1 0))

(defmacro charc (spc x y z)
  `(let*
     ((ch (ignore-errors
	    (aref ,spc ,x ,y ,z))))
     (if ch
       (charv ch)
       0)))

(defun update-char (nspc x y z ch v)
  (if (char= ch #\#)
    (if (or (= v 2) (= v 3))
      (setf (aref nspc x y z) #\#)
      (setf (aref nspc x y z) #\.))
    (if (= v 3)
      (setf (aref nspc x y z) #\#)
      (setf (aref nspc x y z) #\.))))

(defun eval-char (spc nspc x y z)
  (labels
    ((ez (s xs ys zs xe ye ze v)
	 (if (> zs ze)
	   v
	   (ez
	     s xs ys (+ zs 1) xe ye ze
	     (ey s xs ys zs xe ye ze v))))
     (ey (s xs ys zs xe ye ze v)
	 (if (> ys ye)
	   v
	   (ey
	     s xs (+ ys 1) zs xe ye ze
	     (ex s xs ys zs xe ye ze v))))
     (ex (s xs ys zs xe ye ze v)
	 (if (> xs xe)
	   v
	   (ex
	     s (+ xs 1) ys zs xe ye ze
	     (+ v (charc s xs ys zs))))))
    (let*
      ((c (aref spc x y z))
       (v (ez spc (- x 1) (- y 1) (- z 1)
	      (+ x 1) (+ y 1) (+ z 1)
	      (- (charv c)))))
      (update-char nspc x y z c v))))

(defun eval-line (spc nspc x y z)
  (if (>= x 0)
    (progn
      (eval-char spc nspc x y z)
      (eval-line spc nspc (- x 1) y z))
    t))

(defun eval-flat (spc nspc x y z)
  (if (>= y 0)
    (progn
      (eval-line spc nspc x y z)
      (eval-flat spc nspc x (- y 1) z))
    t))

(defun eval-step (spc nspc x y z)
  (if (>= z 0)
    (progn
      (eval-flat spc nspc x y z)
      (eval-step spc nspc x y (- z 1)))
    t))
