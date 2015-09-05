(in-package :cl-user)

(defpackage :stash-test
  (:use :cl :prove
        :stash.model
        :stash.views
        :stash))

(in-package :stash-test)

(setf prove:*enable-colors* t)
