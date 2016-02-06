(in-package :stash-test)

(plan 3)

(define-view hello (params)
  (:css "static/hello.css")
  (:css "static/decotate.css")
  (:script (format nil "function myAlert() { alert(\"hello, ~S\"); }"
                   (cdr (assoc :name params))))
  (:div (:button :type button :onclieck "myAlert()")))

(is ())

(finalize)
