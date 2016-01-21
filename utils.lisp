(in-package :stash.utils)

(defun string->hash (string)
  (ironclad:byte-array-to-hex-string
   (ironclad:digest-sequence
    :sha256
    (flexi-streams:string-to-octets string :external-format :utf8))))

(defun format-value (value)
  (typecase value
    (hash-table (format-hash value))
    (t (with-output-to-string (s)
         (pprint value)))))

(defun format-hash (hash)
  (format nil "{~{~{\"~A\" : \"~A\"~}~^ ~}}"
          (loop for key being the hash-keys of hash
             using (hash-value value)
             collect (list key value))))

(defmacro current-file-location ()
  (make-pathname
     :directory (pathname-directory *compile-file-truename*)
     :device (pathname-device *compile-file-truename*)))

(defun request-param-value (param-list key)
  (cdr (assoc key param-list :test #'string=)))

(defun make-response (status &optional headers body)
  (list status headers body))
