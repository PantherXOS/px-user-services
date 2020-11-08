;;; User service definiiton for syncthing
;;; Author: Reza Alizadeh Majd <r.majd@pantherx.org>
;;;

(define syncthing
  (make <service>
    #:provides '(syncthing)
    #:docstring "Run `syncthing` without calling the browser"
    #:start (make-forkexec-constructor
             '("syncthing" "-no-browser")
             #:log-file (string-append (getenv "HOME")
                                       "/.syncthing.log"))
    #:stop (make-kill-destructor)
    #:respawn? #t))

(register-services syncthing)
(start syncthing)
