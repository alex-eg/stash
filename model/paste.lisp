(in-package :stash.model)

(deftable paste ()
  (short-id :type text :uniquep t)
  (hash :type text :uniquep t)
  (timestamp :type timestamp)
  (caption :type text)
  (body :type text))

(defun pygmentize (code language)
  (with-input-from-string (s code)
    (uiop/run-program:run-program
     (format nil "pygmentize -f html -l ~a" language)
     :output '(:string :stripped t)
     :input s)))
