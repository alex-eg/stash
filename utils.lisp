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

(defun escape-string (string &key (replace-newlines-with-br nil))
  (with-output-to-string (s)
    (map nil
         (lambda (char)
           (case char
             ((#\<)
              (write-sequence "&lt;" s))
             ((#\>)
              (write-sequence "&gt;" s))
             ((#\&)
              (write-sequence "&amp;" s))
             ((#\')
              (write-sequence "&#039;" s))
             ((#\")
              (write-sequence "&quot;" s))
             ((#\Return) nil)
             ((#\Newline)
              (if replace-newlines-with-br
                  (write-sequence "<br>" s)
                  (format s "~c" char)))
             (otherwise
              (format s "~c" char))))
         string)))

(defun relative-path (path)
  (asdf:system-relative-pathname :stash path))

(defun @-dispatcher (stream char)
  (let ((next-char (peek-char nil stream)))
    (cond ((or (char= next-char #\Newline)
               (char= next-char #\Space))
           'ps:@)
          (t (annot.syntax:annotation-syntax-reader stream char)))))

(defmacro enable-annot-syntax ()
  '(eval-when (:compile-toplevel :load-toplevel :execute)
    (setf *readtable* (copy-readtable nil))
    (set-macro-character #\@ #'@-dispatcher)))
