(in-package :stash.views)

(define-view main-page (params)
  (str (header params))
  (:h4 "Welcome to stash")
  (if current-user%
      (htm (:br)
           (str "You are logged in!"))))
