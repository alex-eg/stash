(in-package :stash.views)

(define-view posts-list-page (params)
  (with-database (db "stash")
    (with-collection (c "posts" db)
      (let ((posts (mongo:find c)))
        (loop :for p :in posts :do
           (str (format-hash p)))))))
