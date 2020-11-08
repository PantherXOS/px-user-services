;;; User service definiiton for mcron service
;;; Author: Reza Alizadeh Majd <r.majd@pantherx.org>
;;;

(use-modules (guix build utils))

(define mcron
  (make <service>
    #:provides '(mcron)
    #:docstring "Run `mcron` as a daemon"
    #:start (make-forkexec-constructor '("mcron"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(mkdir-p (string-append (getenv "HOME") "/.config/cron"))

(register-services mcron)
(start mcron)
