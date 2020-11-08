(use-modules (guix build utils)
             (shepherd service)
             ((ice-9 ftw) #:select (scandir)))

;; Send shepherd in to the background
(action 'shepherd 'daemonize)

(define (load-services path)
  (if (access? path F_OK)
    (for-each
      (lambda (file)
        (display (string-append "   - " path "/" file "\n"))
        (load (string-append path "/" file)))
      (scandir path
              (lambda (file)
                (and (string-suffix? ".scm" file)
                    (not (string=? "init.scm" file))))))))


;; Load all the files in the directory 'services' with suffix '.scm'.
(let ((user-path            (string-append (getenv "HOME") "/.userdata/services"))
      (user-profile-path    (string-append (getenv "HOME") ".guix-profile/etc/px/services"))
      (system-profile-path  "/run/current-system/profile/etc/px/services"))
    (mkdir-p user-path)
    (load-services user-path)
    (load-services user-profile-path)
    (load-services system-profile-path))

; (for-each
;  (lambda (file)
;    (load (string-append "services/" file)))
;  (scandir (string-append (dirname (current-filename)) "/services")
;           (lambda (file)
;             (string-suffix? ".scm" file))))
