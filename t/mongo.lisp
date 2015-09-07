(in-package :stash-test)

(defvar *user-names*
  '("grizzlycute" "captainfroglet" "petnervous" "frozenpuppy" "moonmoon"
    "chaosslimyhammer" "chaosgazelle" "purepony" "supersonicwhitehook"
    "chickenweasel" "thewhale" "staragent" "coyotemodern" "honeyeternal"
    "thehatchling" "irisboiling" "duckiebitter" "studentstudent" "horsehorse"
    "thegazelle" "purplerayz" "ministonyorangutan" "weaselrunny" "badwildcat"
    "losfairy" "sugarhoney" "gladiatorgruesome" "runnyviper" "pigletstormy"
    "thefiend" "roughmink" "puppymysterious" "woodenfistyjackal" "hiddeneagle"))

(plan 15)

(is-error (make-instance 'user) 'simple-error)

(macrolet
    ((test-database ()
       '(progn
         (is (mongo:remove user (make-hash-table)) nil)
         (is (mongo:find user) nil)
         (is-error (store not-mongo-storable db ) 'simple-error)
         (is (store user1 db) nil)
         (is (store user2 db) nil)
         (is (length (mongo:find user)) 2)
         (ok (mongo:find user)))))

  (let* ((user1 (make-instance 'user
                               :collection "user"
                               :login "test-user"
                               :email "test@test.net"
                               :handle "shown-name"
                               :password "password-hash"
                               :friend-list '()))
         (user2 (make-instance 'user
                               :collection "user"
                               :login "test-user2"
                               :friend-list (list user1)))
         (not-mongo-storable (make-instance 'standard-object)))
    (with-database (db "stash-test")
      (with-collection (user "user" db)
        (test-database)))
    (with-database-and-collection (user "user" db "stash-test")
      (test-database))))

(finalize)
