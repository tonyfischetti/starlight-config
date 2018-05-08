
#lang racket

(require racket/runtime-path
         (for-syntax racket/base))

(provide incpath)

(define-runtime-path
  incpath (string->path (string-append 
                          (path->string (find-system-path 'home-dir))
                          "/.starlight/config.rkt")))
