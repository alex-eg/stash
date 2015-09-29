(in-package :stash.utils)

(defun string->hash (string)
  (ironclad:byte-array-to-hex-string
   (ironclad:digest-sequence
    :sha256
    (flexi-streams:string-to-octets string))))

(defun format-hash (hash)
  (format nil "#HASH(~{~{(~a . ~a)~}~^ ~})"
          (loop for key being the hash-keys of object
             using (hash-value value)
             collect (list key value))))
