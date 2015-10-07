(in-package :stash.views)

(define-view newentry (params)
  (str (header params))
  (:form (:input :type "text")))
