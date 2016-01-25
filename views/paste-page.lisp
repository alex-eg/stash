(in-package :stash.views)

(define-view create-paste-page (params)
  (str (header params))
  (:form :action "/paste/create"
         :method "post"
         (:input :type "text" :name "paste-caption") (:br)
         (:textarea :cols "80" :rows "10" :name "paste-body") (:br)
         (:input :type "submit" :value "Create new paste") (:br)))

(define-view show-paste-page (params)
  (str (header params))
  (with-database (db "stash")
    (let* ((hash (cadr (assoc :splat params)))
           (paste (car (find (make-instance 'paste :hash hash)
                             db))))
      (or (and paste (htm (:pre (:code (fmt "~A" (gethash "BODY" paste))))))
          (make-response 404)))))
