(mongo:with-client (c (mongo:create-mongo-client
                       :usocket
                       :server (make-instance 'mongo:server-config
                                              :hostname "localhost"
                                              :port 27017)
                       :write-concern mongo:+write-concern-normal+))
  (let ((db (make-instance 'mongo:database :mongo-client c
                           :name "test")))
    (let ((col (mongo:collection db "posts"))
          (h (make-hash-table)))
      (setf (gethash "foo" h) "bar")
      (setf (gethash "num" h) 822)
      (mongo:insert col h))))
