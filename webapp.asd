(defsystem webapp
  :version "0.0.1"
  :author "Alex Segura <alex@lispmachin.es>"
  :depends-on (#:hunchentoot
               #:postmodern
               #:yason
               #:cl-who
               #:css-lite
               #:quri)
  :pathname "src/"
  :serial t
  :components
  ((:file "package")
   (:file "annotation")
   (:file "routes")))
