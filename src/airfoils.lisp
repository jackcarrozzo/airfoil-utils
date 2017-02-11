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
