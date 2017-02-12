(in-package :cl-user)
(defpackage airfoil-utils
  (:use :cl
        :alexandria
        :airfoil-utils.helpers
        :airfoil-utils.airfoils
        :airfoil-utils.http
        :airfoil-utils.math)
  (:export
   :print-2d-gcode
   :fetch-available-airfoils
   :fetch-airfoil-pts
   :*plot-pts*
   :start-http
   :stop-http
   :translate-2d
   :scale-2d
   :rotate-2d
   ;; todo:
   ))
(in-package :airfoil-utils)
(cl-syntax:use-syntax :annot)

@export
(defvar *plot-pts* nil)
