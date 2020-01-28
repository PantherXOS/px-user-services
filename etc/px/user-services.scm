(use-modules (guix)
             (gnu))

(define (make-service . args)
  (apply make <service> args))

(define mcron 
  (make-service
    #:provides '(mcron)
    #:start (make-forkexec-constructor '("mcron"))
    #:stop (make-kill-destructor)))


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

(register-services px-secret-service
                     px-events-service
                     px-accounts-service
                     px-settings-service)
(action 'shepherd 'daemonize)


(for-each start 
          (list mcron
                px-secret-service
                px-events-service
                px-accounts-service
                px-settings-service))