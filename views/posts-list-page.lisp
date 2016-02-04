(in-package :stash.views)

(define-view posts-list-page (params)
  (str (header params))
  (:div (str "Now with markdown support!"))
  (with-database (db "stash")
    (let ((posts (find (all-collection "posts" 'stash.model::post
                                       ) db)))
      (loop :for p :in posts :do
         (htm
          (:div :class "post"
                (:h3 (str (post-caption p)))
                (:hr)
                (str (post-body p)))))))
  (:hr)
  (:form :action "./posts"
         :method "post"
         (:input :type "text" :name "post-caption") (:br)
         (:textarea :cols "80" :rows "10" :name "post-body") (:br)
         (:input :type "submit" :value "Create new post") (:br)))
