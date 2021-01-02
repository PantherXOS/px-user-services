
(define (make-service . args)
  (apply make <service> args))


(define px-contacts-calendar-service
  (make-service
    #:provides '(px-contacts-calendar-service)
    #:requires '(px-secret-service
                 px-events-service
                 px-accounts-service)
    #:start (make-forkexec-constructor '("etesync-dav"))
    #:stop (make-kill-destructor)
    #:enable? #t))

(define px-secret-service
  (make-service
    #:provides '(px-secret-service)
    #:start (make-forkexec-constructor '("px-secret-service"))
    #:stop (make-kill-destructor)
    #:enable? #t))

(define px-events-service
  (make-service
    #:provides '(px-events-service)
    #:start (make-forkexec-constructor '("px-events-service"))
    #:stop (make-kill-destructor)
    #:enabled? #t))

(define px-accounts-service
  (make-service
    #:provides '(px-accounts-service)
    #:requires '(px-secret-service
                 px-events-service)
    #:start (make-forkexec-constructor '("px-accounts-service"))
    #:stop (make-kill-destructor)
    #:enabled? #t))

(define px-settings-service
  (make-service
    #:provides '(px-settings-service)
    #:requires '(px-accounts-service)
    #:start (make-forkexec-constructor '("px-settings-service"))
    #:stop (make-kill-destructor)
    #:enabled? #t))

(define px-mastodon-service
  (make-service
    #:provides '(px-mastodon-service)
    #:requires '(px-secret-service
                 px-events-service
                 px-accounts-service)
    #:start (make-forkexec-constructor '("px-mastodon-service"))
    #:stop (make-kill-destructor)
    #:enabled? #t))

(define px-hub-service
  (make-service
    #:provides '(px-hub-service)
    #:requires '(px-events-service
                 px-accounts-service)
    #:start (make-forkexec-constructor '("px-hub-service"))
    #:stop (make-kill-destructor)
    #:enabled? #t))

(register-services px-secret-service
                   px-events-service
                   px-accounts-service
                   px-settings-service
                   px-hub-service
                   px-mastodon-service
                   px-contacts-calendar-service)

(for-each start 
          (list px-contacts-calendar-service
                px-secret-service
                px-events-service
                px-accounts-service
                px-settings-service
                px-hub-service
                px-mastodon-service))
