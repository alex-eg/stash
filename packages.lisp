(in-package :cl-user)

(defpackage :stash.model
  (:use :cl))

(defpackage :stash.views
  (:use :cl))

(defpackage :stash
  (:use :cl
        :stash.views
        :stash.model)
  (:export :start))
