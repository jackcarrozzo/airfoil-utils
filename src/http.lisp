(in-package :cl-user)
(defpackage airfoil-utils.http
  (:use :cl
        :ningle
        :clack)
  (:import-from :lack.request
                :request
                :request-method
                :request-uri)
  (:import-from :lack.response
                :response-headers
                :response-body)
  (:import-from :cl-json
                :encode-json-to-string
                :encode-json-alist-to-string
                :encode-json-plist-to-string))
(in-package :airfoil-utils.http)
(cl-syntax:use-syntax :annot)

(defvar *app* (make-instance 'ningle:<app>))


(defun set-cors-headers ()
  (setf (lack.response:response-headers *response*)
        (append (lack.response:response-headers *response*)
                (list :content-type "application/json")))
  (setf (lack.response:response-headers *response*)
        (append (lack.response:response-headers *response*)
                (list :access-control-allow-origin "*"))))

#|(setf (ningle:route *app* "/")
      #'(lambda (params)
          (declare (ignore params))

          "hi from airfoil-utils! put vis page here n stuff."))|#

(defun fetch-naca-pts (label)
  (format t "naca label: ~a~%" label)
  '((1.0 0.0)
    (1.0 1.1)))

(setf (ningle:route *app* "/airfoil-pts/:arg")
      #'(lambda (params)
          (set-cors-headers)
          (let ((arg (rest (assoc :arg params))))
            (cl-json:encode-json-to-string
             `((plot--set . ,arg)
               (plot--pts . ,(if (string= arg "current")
                                 airfoil-utils.math:*plot-pts*
                                 (fetch-naca-pts arg))))))))

@export
(defparameter +clack-h+ nil)

@export
(defun start-http (&key (port 8803))
  (setf +clack-h+
        (clack:clackup *app*
                       :server :toot
                       :port port)))
@export
(defun stop-http ()
  (clack:stop +clack-h+))
