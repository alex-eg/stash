(in-package :cl-user)

(defpackage :stash.utils
  (:use :cl)
  (:export :string->hash))

(defpackage :stash.model
  (:use :cl :stash.utils)
  (:export :with-database
           :with-collection
           :with-database-and-collection
           :store

           :user
           :user-login
           :user-password

           :config
           :read-config-file
           :config-development-p
           :load-config-from-file

           :post))

(defpackage :stash.views
  (:use :cl
        :cl-who))

(defpackage :stash
  (:use :cl
        :stash.utils
        :stash.views
        :stash.model)
  (:export :start))
