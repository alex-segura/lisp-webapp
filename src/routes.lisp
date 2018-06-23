(in-package #:webapp)

(define-easy-handler (hello :uri "/hello") (name)
  (setf (content-type*) "text/html")
  (with-html-output-to-string (s)
    (:html
      (:head
       (:title "Hello")
       (:body
        (:p (format s "Hello ~a.~%" name)))))))

(define-easy-handler (get-annotation :uri "/annotation") (site-id user-id content-type)
  (setf (content-type*) "text/plain")
  (case (request-method  *request*)
    (:get
     (format nil "Params: ~{~a ~}~%"
             (list "Site-Id: "site-id
                   "User-Id:" user-id
                   "Content-Type:" content-type)))
    (:post  (format nil "Posted.~%"))))

(defun handler-name (uri)
  (intern (format nil "HANDLE-~a" (string-upcase uri))))

#+nil
(defmacro defroutes (api-name options &body body)
  (declare (ignore api-name options))
  (let ((routes (make-hash-table :test #'equal)))
    (loop :for route :in body
       :do (destructuring-bind (method uri implementation)
               route
             (let ((handlers (gethash uri routes)))
               (setf (gethash uri routes)
                     (cons `(,method ,implementation)
                           handlers)))))
    `(progn
       ,@(loop :for k :being :the :hash-keys :of routes
            :collect (multiple-value-bind (handlers foundp)
                         (gethash k routes)
                       (declare (ignore foundp))
                       `(define-easy-handler (,(handler-name k) :uri ,k) (&rest params)
                          (case (request-type *request*)
                            ,@(mapcar #'(lambda (handler)
                                          (destructuring-bind (method implementation)
                                              handler
                                            `(,method (apply (function ,implementation) params))))
                                      handlers))))))))

 #+nil
(defroutes my-api ()
  (:post "/annotation" post-annotation)
  (:get "/annotation" get-annotation)
  (:get "/user" get-user)
  (:post "/user" post-user))
