# PantherX Desktop User Services

User Services definition package for PantherX Desktop

## Add New User Services

in order to add new services, you need to implement service definition in shepherd script and update the service cleanup script.

### 1. Add service definition

in order to add new service, you need update the [`user-services`](etc/px/user-services.scm) file.

first you need to add service definition according to following definition:

```scheme
(define service-name
  (make-service
    #:provides '(service-name)
    #:requires '(service-dependency-1
                 service-dependency-2)
    #:start (make-forkexec-constructor '("service package"))
    #:stop  (make-kill-destructor)
    #:enabled? #t))
```

now you need to register service to list of shepherd services:

```diff
 (register-services service-1
                    service-2
                    ...
+                   service-name
                    ...)
```

and finally you need to add service to list of auto starting services:

```diff
(for-each start
          (list service-1
                service-2
                ...
+               service-name
                ...))
```

### 2. Update service startup script

after adding the service definition, you need to update service startup script to cleanup the previous service executions during service startup. for this, you just need to add service process-name to list of user services at the beginning of [`px-user-services.sh`](bin/px-user-services.sh) file:

```diff
services=(
    service-process-name-1
    service-process-name-2
    ...
+   service-process-name
    ...
)
```
