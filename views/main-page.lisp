(in-package :stash.views)

(define-view main-page (params)
  (str (header params))
  (:br)
  (:h3 "Welcome")
  (if (user-logged-in)
      (htm (:br)
           (:b "You are logged in!"))))
