(in-package :cl-user)
(defpackage airfoil-utils.airfoils
  (:use :cl
        :airfoil-utils.math
        :alexandria)
  (:import-from :drakma
                :http-request))
(in-package :airfoil-utils.airfoils)
(cl-syntax:use-syntax :annot)

(defparameter +airfoils-url+ "http://m-selig.ae.illinois.edu/ads/coord/")

@export
(defvar *cached-airfoils* (make-hash-table :test 'equal))

;; add a temp airfoil so i can work on this
;; when i dont have internet access
(setf (gethash "temp-naca2408" *cached-airfoils*)
      '((1.0 8.4e-4) (0.95033 0.00855) (0.90054 0.01575) (0.80078 0.02858)
        (0.70081 0.03942) (0.60068 0.0482) (0.50039 0.05473) (0.4 0.05869)
        (0.299 0.05875) (0.24852 0.05677) (0.19809 0.0532) (0.14778 0.04776)
        (0.09768 0.03987) (0.07273 0.03471) (0.04794 0.02829) (0.02337 0.01944)
        (0.01128 0.0138) (0.0 0.0) (0.01372 -0.01134) (0.02663 -0.01493)
        (0.05206 -0.01891) (0.07727 -0.02111) (0.10232 -0.02237) (0.15222 -0.02338)
        (0.20191 -0.0232) (0.25148 -0.02239) (0.301 -0.02125) (0.4 -0.01869)
        (0.49961 -0.01585) (0.59932 -0.01264) (0.69919 -0.00942) (0.79922 -0.00636)
        (0.89946 -0.00353) (0.94967 -0.00217) (1.0 -8.4e-4)))

@export
(defun list-cached-airfoils ()
  (alexandria:hash-table-keys *cached-airfoils*))

@export
(defun fetch-available-airfoils ()
  (mapcar #'(lambda (i)
              (let ((len (length i)))
                (subseq i 1 (- len 4))))
          (cl-ppcre:all-matches-as-strings
           " [a-zA-Z0-9]+\.dat"
           (drakma:http-request +airfoils-url+))))

@export
(defun fetch-airfoil-pts (label &key (force-reload nil))
  (let* ((fmtd-label (string-downcase label))
        (cached-pts (gethash fmtd-label *cached-airfoils*)))

    (cond ((or force-reload (not cached-pts))
           (values
            (setf (gethash fmtd-label *cached-airfoils*)
                  (parse-pts-from-selig-dat
                   (drakma:http-request
                    (format nil "~a~a.dat" +airfoils-url+ fmtd-label))))
            t)) ;; second value tells whether we fetched or fed from cache
          (t
           cached-pts))))

(defun parse-pts-from-selig-dat (def)
  (rest ;; the first point is the label def
   (mapcar #'(lambda (o)
               (mapcar
                #'float-from-str
                (cl-ppcre:split " +" o)))
           (cl-ppcre:split (string #\newline)
                           def))))
