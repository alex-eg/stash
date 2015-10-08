(in-package :stash.views)

(define-view newentry (params)
  (str (header params))
  (:form :action "./newentry"
         :method "post"
         (:input :type "text" :name "caption")
         (:textarea :cols "80" :rows "20" :name "post-body")
         (:input :type "submit" :value "Create new post")))
