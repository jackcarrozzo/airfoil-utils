(in-package :cl-user)
(defpackage airfoil-utils.helpers
  (:use :cl))
(in-package :airfoil-utils.helpers)
(cl-syntax:use-syntax :annot)

;; leaving the full package names in these funcs so
;; they're easy to use as examples

@export
(defun print-2d-gcode (airfoil-name &key (angle 0.0) (scale 1.0) (move-x 0.0) (move-y 0.0))
  ;; todo: pre and post amble
  (airfoil-utils.gcode:print-2d-cuts
   (airfoil-utils.math:translate-2d
    move-x move-y
    (airfoil-utils.math:scale-2d
     scale
     (airfoil-utils.math:rotate-2d
      angle
      (airfoil-utils.airfoils:fetch-airfoil-pts airfoil-name))))))
