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
                  (princ char s)))
             (otherwise
              (princ char s))))
         string)))

(defun relative-path (path)
  (asdf:system-relative-pathname :stash path))

(defun @-dispatcher (stream char)
  ;; Readtable modification for @-character.
  ;; It is used in cl-annot, but it also used in cl-js,
  ;; and we need to distinguish this cases
  ;; or cl-js will end fucked up
  (let ((next-char (peek-char nil stream)))
    (cond
      ((or (char= next-char #\Newline)
           (char= next-char #\Space))
       ;; it's javascript!
       'ps:@)
      (t
       ;; otherwise, by deafult, it's a decorator
       (annot.syntax:annotation-syntax-reader stream char)))))

(defmacro enable-annot-syntax ()
  '(eval-when (:compile-toplevel :load-toplevel :execute)
    (setf *readtable* (copy-readtable nil)) ; reset readtable
    (set-macro-character #\@ #'@-dispatcher)))

(annot:defannotation restrict-login (app redirect-form body)
    (:arity 3 :inline t)
  (let ((body (cdddr body))
        (definition (subseq body 0 3)))
    (append definition
            `((if (lucerne-auth:logged-in-p)
                  (progn ,@body)
                  (lucerne.views:not-found ,app))))))

(defun plist->hash (plist)
  (let ((h (make-hash-table :size (/ (length plist) 2))))
    (mapcar
     (lambda (elem)
       (let ((key (car elem))
             (val (cadr elem)))
         (setf (gethash key h) val)))
     (loop
        :for elem :in plist
        :and prev-elem := nil :then elem
        :for flag := nil :then (not flag)
        :if flag :collect (list prev-elem elem)))
    h))

(defun config-list->hash (alist)
  (let ((hash (make-hash-table :size (length alist))))
    (loop
       :for (k v) :in alist
       :do (setf (gethash k hash) v))
    hash))

(defun read-flexi-stream-to-string (stream)
  (with-output-to-string (str)
    (let ((buffer (make-array 1024)))
      (loop
         :for n := (read-sequence buffer stream)
         :until (= 0 n)
         :do (princ (flex:octets-to-string buffer :start 0 :end n) str)))))
