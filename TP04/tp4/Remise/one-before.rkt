#lang racket
(require (for-syntax racket/match
                     (file "../stx-util.rkt")))
(require (for-syntax (file "../stx-list-accessor.rkt")
                     racket/list))


(provide one-before)
(displayln "nom1, prénom1")
(displayln "nom2, prénom2")




(define-syntax one-before
  (λ (stx)
    (match (stx->list stx)
      [(list _) (datum->syntax stx "one-before vide")]
      [(list _ val)
       (displayln (syntax->datum val))
       (datum->syntax stx val)]
      [(list op ... returnVal reste)
       (for-each displayln (map syntax->datum (stx-cdr op)))
       (displayln (syntax->datum reste))
       (datum->syntax stx returnVal)])))

;'(one-before)
;
(one-before)
;
;'---------------
;(newline)
;'(one-before (+ 2 3))
;
(one-before (+ 2 3))
;
;'---------------
;(newline)
;'(one-before (displayln "ligne 1")
;             (displayln "ligne 2")
;             (displayln "ligne 3")
;             (list 1 2 3 'but-last)
;             (displayln "last"))
;
(one-before (displayln "ligne 1")
            (displayln "ligne 2")
            (displayln "ligne 3")
            (list 1 2 3 'but-last)
            (displayln "last"))
;'---------------
;(newline)
;'(one-before '(list 1 2 3 'but-last)
;             (displayln "last"))
;
(one-before (list 1 2 3 'but-last)
            (displayln "last"))
