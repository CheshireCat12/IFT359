#lang racket
(provide (all-defined-out))

#| Il s'agit ici d'ouvrir un fichier pour écrire la trace. Ce fichier sera
   renommé dans le REPL lorsque le programme à tracer sera connu.
|#
(define path-trace (build-path 'same "Trace"))
(define trace-file "trace.txt")

(define trace-file-path (build-path path-trace trace-file))

(define out-port (if trace-file-path
                     (open-output-file trace-file-path
                                       #:mode 'text
                                       #:exists 'replace)
                     ; si on veut voir la trace dans la fenêtre d'interaction
                     (current-output-port)))

(define-values (+indent -indent tab)
  ; Uniquement pour afficher la trace
  (let ([t ""]
        [i "  "])
    (values
     (λ ()
       (set! t (string-append t i))
       t)
     (λ ()
       (set! t (substring t 2))
       t)
     (λ ()
       t))))

(define écrit
  (λ args
    (fprintf out-port (tab))
    (apply fprintf out-port args)))

(define erreur
  (λ (procedure message-format . args)
    (apply écrit message-format args)
    (close-output-port out-port)
    (apply error procedure message-format args)))

;(current-directory)
