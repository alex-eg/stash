(in-package :cl-user)

(defpackage :stash.model
  (:use :cl)
  (:export :with-database
           :with-collection
           :with-database-and-collection
           :store
           :user
           :post))

(defpackage :stash.views
  (:use :cl
        :cl-who))

(defpackage :stash
  (:use :cl
        :stash.views
        :stash.model)
  (:export :start))
