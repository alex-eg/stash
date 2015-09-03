(in-package :cl-user)

(defpackage :stash.model
  (:use :cl))

(defpackage :stash.views
  (:use :cl
        :cl-who))

(defpackage :stash
  (:use :cl
        :stash.views
        :stash.model)
  (:export :start))
