(in-package :stash.views)

(define-view main-page (params)
  (str (header params))
  (:hr)
  (:h4 "Welcome to stash")
  (if (user-logged-in)
      (htm (:br)
           (str "You are logged in!"))))
