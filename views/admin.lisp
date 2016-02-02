(in-package :stash.views)

(define-view admin-page (params)
  (str (header params))
  (:ul
   (:li (:a :href "/admin/settings" (str "Settings")))
   (:li (:a :href "/admin/adduser" (str "Add user")))))
