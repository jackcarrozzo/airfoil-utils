(in-package :cl-user)
(defpackage airfoil-utils.gcode
  (:use :cl
        :alexandria))
(in-package :airfoil-utils.gcode)
(cl-syntax:use-syntax :annot)

(defparameter +default-feed+ 2.0)
(defparameter +clearance-z+ 0.1)
(defparameter +default-cut-increment+ 0.1)
(defparameter +default-final-depth+ 0.51)

(defparameter +num-decimals+ 5)

(defun print-preamble (&key (feed-rate 2.0))
  (format t "G64
G17 G20 G40 G49
G54 G80 G90 G94~%~%f~f~%~%" feed-rate))

(defun print-end ()
  (format t "g0 z~f~%" +clearance-z+)
  (format t "m02~%"))

(defun print-code (cut-pts)
  (print-preamble)

  (format t "#4 = 20 ( deg increment )~%")
  (format t "#3 = 21 ( while a pos is LT this )~%")
  (format t "( #3 = 361 )~%")
  (format t "#2 = 0~%o102 while [#2 LT #3]~%")
  (format t "(debug, param 2 = #2)~%")
  (format t "g0 a#2~%~%")

  (print-cut-code cut-pts)

  (format t "~%#2 = [#2+#4]~%o102 endwhile~%~%")

  (print-end))

(defun print-cut-code (cut-pts &key (loop-p t) (lead-in-x 0.3) (lead-in-y 0.3)
                                 (final-depth +default-final-depth+)
                                 (cut-increment +default-cut-increment+))
  (let* ((pts (reverse cut-pts))
         (first-pt (first pts))
         (first-x (first first-pt))
         (first-y (second first-pt))
         (entry-x (+ first-x lead-in-x))
         (entry-y (+ first-y lead-in-y)))

    ;; loop cuts; or just the final depth profile
    (if loop-p
        (progn
          (format t "#1 = 0~%")
          (format t "o101 while [#1 GT ~f]~%" (- final-depth cut-increment)))
        (format t "#1 = ~f~%" final-depth))

    ;; to entry pos at clearance
    (format t "g0 x~f y~f z~f~%"
            entry-x entry-y +clearance-z+)

    ;; rapid down to cut depth
    (format t "g0 z#1~%")

    ;; go around the profile
    (loop for this-pt in pts
       do
         (let* ((x (first this-pt))
                (y (second this-pt)))
           (format t "g1 x~f y~f~%" x y)))

    ;; rapid to clearance
    (format t "g0 z~f~%" +clearance-z+)

    ;; end loop
    (when loop-p
      (format t "#1 = [#1-~f]~%" cut-increment)
      (format t "o101 endwhile~%"))))

@export
(defun print-2d-cuts (airfoil-pts &key (stream t))
  (loop for pair in airfoil-pts
     do
       (let ((this-x (first pair))
             (this-y (second pair)))
         (format stream "g1 x~v$ y~v$~%"
                 +num-decimals+ this-x
                 +num-decimals+ this-y))))
