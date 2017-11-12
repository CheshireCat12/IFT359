#lang racket
(require (file "3 méta-évaluateur applicatif.rkt"))
(provide (all-from-out (file "3 méta-évaluateur applicatif.rkt")) all-defined-out )

#| Le repl dans sa forme la plus simple
   Il exécute les expressions données dans fichier
   et les affiche dans la fenêtre d'interaction.
   La trace de l'exécution est conservé dans le fichier
   (string-append "trace-" progr) du répertoire "Trace"
|#

(define path-progr (build-path 'same "Programme")) 
(define progr0 "progr let.txt")
(define progr1 "progr test application de fn.txt")
(define progr2 "progr foldl.txt")
(define progr3 "progr ajout-id-des-define.txt")
(define progr4 "progr-letrec.txt")
(define progr5 "progr-letrec.1.txt")
(define progr6 "progr-abelson-p241-243.txt")
(define progr7 "progr-test.txt")

; Changer la nom du programme afin d'imprimer la trace dans le dossier Trace
(define progr progr5)
;(define path-input (string->path (string-append path-progr progr)))
(define path-input (build-path path-progr progr))


(define progr-ls
  #| Comme il faut détecter tous les define à l'intérieur d'un même espace lexical,
   alors j'ai mis tout les expressions du fichier dans une liste.|#
  (λ (path-progr)
    (let ([input-port (open-input-file path-progr)]
          [ls-input '()])
      (let iter ([ls-input '()]
                 [input (read input-port)])  ;; le read du REPL "Read Eval Print Loop"
        ;; read ignore les commentaires et les lignes vides, il passe simplement par-desssus
        (cond [(or (eq? input 'exit) (eq? input 'stop) (eof-object? input))
               (close-input-port input-port)
               (reverse ls-input)]
              [else
               (when (and (pair? input) (eq? (car input) 'define))
                 (ajout-identificateur-env (cadr input) global-env*))
               (iter (cons input ls-input)(read input-port))])))))

(define repl-progr
  (λ (ls-input)
    (if (null? ls-input)
        (close-output-port out-port)
        (let ([input (car ls-input)])
          (écrit "~%-- new input --~%")
          (printf "~a~%--> ~a~%" input (eval input global-env*)) ; le eval et le print du REPL
          (repl-progr (cdr ls-input))))))

(écrit "Dans environnement global (no 0)~%")

(repl-progr (progr-ls  path-input))


(define new-out-file-path (build-path path-trace (string-append "trace " progr)))
;(define new-out-file-path (string->path (string-append path-trace "trace "progr)))

(let ([exist? (file-exists? new-out-file-path)])
  (when exist?
    (delete-file new-out-file-path)))

(rename-file-or-directory trace-file-path new-out-file-path)
;(current-directory)
