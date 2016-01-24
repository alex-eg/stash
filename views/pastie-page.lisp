(define-view pastie-page (params)
  (str (header params))
  (:form :action "./pastie"
         :method "post"
         (:input :type "text" :name "pastie-caption") (:br)
         (:textarea :cols "80" :rows "10" :name "pastie-body") (:br)
         (:input :type "submit" :value "Create new pastie") (:br))))
