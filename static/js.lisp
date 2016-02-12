(in-package :stash.utils)

(defun download-jquery (path &key (version "2.2.0") (compressed t))
  (flet ((get-jquery-url (version compressed)
           (format nil "http://code.jquery.com/jquery-~a~:[~;.min~].js"
                   version compressed))
         (get-stream (url)
           (multiple-value-bind (stream code)
               (drakma:http-request url
                                    :method :get
                                    :want-stream t)
             (if (not (= code 200))
                 (error "Failed to download jquery")
                 stream)))
         (save-stream-to-file (stream jquery-file)
           (let* ((read-size 512)
                  (array (make-array read-size :element-type '(unsigned-byte 8))))
             (with-open-file (file jquery-file :direction :output
                                   :if-exists :error
                                   :element-type '(unsigned-byte 8))
               (loop
                  :do (let ((read-bytes (read-sequence array stream)))
                        (write-sequence array file :end read-bytes)
                        (if (< read-bytes read-size)
                            (return))))))))
    (let ((jquery-file (relative-path path)))
      (unless (probe-file jquery-file)
        (save-stream-to-file (get-stream (get-jquery-url version compressed))
                             jquery-file)))))
