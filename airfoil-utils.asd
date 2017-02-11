(in-package :cl-user)
(defpackage airfoil-utils-asd
  (:use :cl :asdf))
(in-package :airfoil-utils-asd)

(defsystem airfoil-utils
  :version "0.1"
  :author "Jack Carrozzo"
  :license "MIT"
  :depends-on (:cl-ppcre
               :cl-syntax-annot
               :cl-json
               :drakma
               :alexandria
               :ningle
               :clack)
  :components ((:module "src"
                        :components
                        ((:file "http"  :depends-on ("math"))
                         (:file "airfoils" :depends-on ("math"))
                         (:file "gcode")
                         (:file "math")
                         (:file "helpers" :depends-on ("math" "gcode" "airfoils" "http"))
                         (:file "main" :depends-on ("math" "gcode" "airfoils" "http" "helpers")))))
  :description ""
  :in-order-to ((test-op (load-op airfoil-utils-test))))
