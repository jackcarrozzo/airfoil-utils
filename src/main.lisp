(in-package :cl-user)
(defpackage airfoil-utils
  (:use :cl
        :alexandria
        :airfoil-utils.helpers
        :airfoil-utils.airfoils)
  (:export
   :print-2d-gcode
   :fetch-available-airfoils
   ;; todo:
   ))
(in-package :airfoil-utils)
(cl-syntax:use-syntax :annot)
