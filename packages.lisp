(in-package :cl-user)

(defpackage :stash.utils
  (:use :cl)
  (:export :string->hash
           :format-hash
           :format-value
           :current-file-location
           :request-param-value
           :make-response))

(defpackage :stash.model
  (:use :cl :stash.utils)
  (:export :with-database
           :with-collection
           :with-database-and-collection
           :store
           :mongo-id

           :user
           :user-login
           :user-password
           :user-authorized-p

           :post
           :markdown->html

           :config
           :static-path
           :root-path

           :read-config-file
           :config-development-p
           :load-config-from-file

           :post))

(defpackage :stash.views
  (:use :cl
        :cl-who
        :stash.model
        :stash.utils
        :parenscript)
  (:export :generate-general-css))

(defpackage :stash
  (:use :cl
        :anaphora
        :stash.utils
        :stash.views
        :stash.model)
  (:export :start
           :start-server
           :stop-server
           :deploy))
