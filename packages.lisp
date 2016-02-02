(in-package :cl-user)

(defpackage :stash.utils
  (:use :cl)
  (:export :string->hash
           :format-hash
           :format-value
           :current-file-location
           :request-param-value
           :make-response
           :escape-string
           :session))

(defpackage :stash.model
  (:use :cl :stash.utils)
  (:shadow :remove
           :find)
  (:export :with-database
           :with-collection
           :with-database-and-collection
           :store
           :remove
           :find
           :mongo-id
           :all-collection

           :user
           :user-login
           :user-password
           :user-authorizedp
           :user-adminp

           :post
           :markdown->html

           :paste
           :pygmentize

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
  (:shadowing-import-from :stash.model
                          :remove
                          :find)
  (:shadowing-import-from :stash.utils
                          :escape-string)
  (:export :generate-general-css
           :generate-pygments-css

           :main-page
           :login-page
           :hello-page
           :posts-list-page

           :admin-page
           :admin-settings-page
           :add-user-page

           :create-paste-page
           :show-paste-page
           :simple-script))

(defpackage :stash
  (:use :cl
        :anaphora
        :stash.utils
        :stash.views
        :stash.model)
  (:shadowing-import-from :stash.model
                          :remove
                          :find)
  (:export :start
           :start-server
           :stop-server
           :deploy))
