(in-package :stash.views)

(define-view posts-list-page (params)
  (str (header params))
  (with-database-and-collection (c "posts" db "stash")
    (let ((posts (mongo:find c)))
      (loop :for p :in posts :do
        (htm
         (:ul
          (:li (str (format-hash p)))))))))
