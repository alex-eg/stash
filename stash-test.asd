(in-package :cl-user)

(defpackage :stash-test-asdf
  (:use :cl :asdf))
(in-package :stash-test-asdf)

(defsystem :stash-test
  :components
  ((:module "t"
            :componenst
            ((:file "mongo"))))

  :depends-on (:stash
               :prove)

  :defsystem-depends-on (:prove-asdf)

  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c)))
