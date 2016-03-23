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
           :relative-path
           :enable-annot-syntax
           :download-jquery
           :restrict-login
           :plist->hash
           :read-flexi-stream-to-string))

(defpackage :stash.model
  (:use :cl :stash.utils :closer-mop)
  (:shadow :remove
           :find)
  (:shadowing-import-from :closer-mop
                          :standard-method :standard-generic-function
                          :defmethod :defgeneric :standard-class)
  (:export :with-database
           :with-collection
           :with-database-and-collection

           :create-index

           :store
           :store-one
           :remove
           :find
           :mongo-id
           :all-collection

           :collection

           :user
           :user-login
           :user-email
           :user-handle
           :user-password
           :user-authorizedp
           :user-adminp

           :post
           :post-author-id
           :post-caption
           :post-body
           :post-visibility
           :markdown->html

           :paste
           :pygmentize

           :config
           :static-path
           :root-path
           :config-domain-name
           :*config*

           :read-config-file
           :config-development-p
           :load-config-from-file

           :post))

(defpackage :stash.views
  (:use :cl
        :lucerne
        :stash.model
        :stash.utils)
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
        :parenscript
        :anaphora
        :stash.utils
        :stash.views
        :stash.model)
  (:shadowing-import-from :stash.model
                          :remove
                          :find)
  (:export :start-app
           :app
           :start-server
           :stop-server
           :deploy))
