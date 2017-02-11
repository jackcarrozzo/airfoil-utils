(in-package :cl-user)
(defpackage airfoil-utils.math
  (:use :cl
        :alexandria))
(in-package :airfoil-utils.math)
(cl-syntax:use-syntax :annot)

;; todo: tests

;; todo: add default transforms for sweep, angle adj, width, twist

@export
(defvar *plot-pts* '((0.0 0.0)))

;; todo:
@export
(defvar +naca2408-pts+ '())

@export
(defun float-from-str (f)
  (with-input-from-string (in f)
    (read in)))

;; returns list of radians, dist pairs
@export
(defun xy-pairs-to-polar (pairs)
  (loop for pair in pairs
     collecting
       (let ((x-val (first pair))
             (y-val (second pair)))
         (list
          (atan (/ y-val (+ x-val 0.00000000001))) ;; :-\
          (sqrt (+ (* x-val x-val) (* y-val y-val)))))))

;; and back the other way
@export
(defun polar-pairs-to-xy (pairs)
  (loop for pair in pairs
     collecting
       (let ((rads (first pair))
             (rdist (second pair)))
         (list
          (* rdist (cos rads))
          (* rdist (sin rads))))))

@export
(defun deg2rad (deg)
  (/ (* pi deg) 180))

@export
(defun rad2deg (rad)
  (/ (* 180 rad) pi))

@export
(defun rotate-2d (angle-deg pts)
  (polar-pairs-to-xy
   (loop for pair in (xy-pairs-to-polar pts)
      collecting
        (let ((theta (rad2deg (first pair)))
              (rdist (second pair)))
          (list
           (deg2rad (+ theta angle-deg))
           rdist)))))

@export
(defun scale-2d (scale pts)
  (mapcar
   #'(lambda (pt)
       (let ((pt-x (first pt))
             (pt-y (second pt)))
         (list
          (* scale pt-x)
          (* scale pt-y))))
   pts))

@export
(defun translate-2d (dx dy pts)
  (mapcar
   #'(lambda (pt)
       (let ((pt-x (first pt))
             (pt-y (second pt)))
         (list
          (+ dx pt-x)
          (+ dy pt-y))))
   pts))

@export
(defun xy-pairs-to-alist (pairs)
  (loop for pair in pairs
     collecting
       `((:x . ,(first pair))
         (:y . ,(second pair)))))

;; extend profile along z axis; create single list of 3-space pts
@export
(defun extrude-profile (len pts &key (dx 0.05))
  (loop for zl from 0 to len by dx
     appending
       (mapcar #'(lambda (i) (append i `((:z . ,zl))))
               (xy-pairs-to-alist pts))))

@export


;;; todo: redo this shit:
@export
(defun set-plot-pts ()
  (setf *plot-pts* nil)
  (attach-root)
  (loop for depth from 0.0 to 4.0 by 0.1
     do
       (loop
          for pair in
            (polar-pairs-to-xy
             (example-transform
              (xy-pairs-to-polar
               +naca2408-pts+)
              depth))
          do
            (push
             `((:x . ,depth)
               (:y . ,(first pair))
               (:z . ,(second pair)))
             *plot-pts*))))

@export
(defun prepare-pairs (depth)
  (polar-pairs-to-xy
   (example-transform
    (xy-pairs-to-polar +naca2408-pts+)
    depth)))


@export
(defun attach-root ()
  ;; reminder that x and z are flipped for the 3-axis milling export

  (push
   '((:x . -0.1) (:y . -0.1) (:z . 0.1))
   *plot-pts*)
  (push
   '((:x . -0.1) (:y . 1.0) (:z . 0.1))
   *plot-pts*)
  (push
   '((:x . -0.1) (:y . 1.0) (:z . -0.6))
   *plot-pts*)
  (push
   '((:x . -0.1) (:y . -0.1) (:z . -0.6))
   *plot-pts*)
  (push
   '((:x . -0.1) (:y . -0.1) (:z . 0.1))
   *plot-pts*)

  (push
   '((:x . 0.0) (:y . -0.1) (:z . 0.1))
   *plot-pts*)
  (push
   '((:x . 0.0) (:y . 1.0) (:z . 0.1))
   *plot-pts*)
  (push
   '((:x . 0.0) (:y . 1.0) (:z . -0.6))
   *plot-pts*)
  (push
   '((:x . 0.0) (:y . -0.1) (:z . -0.6))
   *plot-pts*)
  (push
   '((:x . 0.0) (:y . -0.1) (:z . 0.1))
   *plot-pts*))

;;
