(in-package :stash.views)

(define-view newentry (params)
  (str (header params))
  (:form :action "./newentry"
         :method "post"
         (:input :type "text" :name "caption") (:br)
         (:textarea :cols "80" :rows "10" :name "post-body") (:br)
         (:input :type "submit" :value "Create new post") (:br)))
