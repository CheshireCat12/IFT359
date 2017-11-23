#lang racket
(require (for-syntax racket/match
                     (file "../stx-util.rkt")))
(require (for-syntax (file "../stx-list-accessor.rkt")
                     racket/list))

(provide  ~~)
(displayln "nom1, prénom1")
(displayln "nom2, prénom2")


(define-syntax ~~
  (λ (stx)
    (displayln (syntax->datum stx))
    (match (stx->list stx)
      [(list-rest _ reste)
       #:when  (eq? (syntax->datum (stx-car reste)) (quote ~));(identifier? (syntax->datum (stx-car reste))))
       (if (null? (stx-cddr reste))
           (datum->syntax stx `(list ,(syntax->datum (stx-cadr reste))))
           ;(displayln  `(unwrap (map syntax->datum ,(stx-cddr reste)))) 
           (datum->syntax stx `(begin 
                          (append (list ,(syntax->datum (stx-cadr reste)))  (~~  ,@(stx-cddr reste)   )))
           ))]
      [(list-rest _ reste)
       #:when  (eq? (syntax->datum (stx-car reste)) (quote ~@))
       (datum->syntax stx `,(syntax->datum (stx-cadr reste)))]
      [(list-rest _ val) (datum->syntax stx  `',val)]
      )))

(define (unwrap lst)
  (if (null? lst)
      '()
      (append (car lst) (cdr lst))))

;'(define b 'b-symbol)
(define b 'b-symbol)
;'(define c 'c-symbol)
(define c 'c-symbol)
;'(define trois 3)
(define trois 3)
;'(define ls (list '+ '* '&))
(define ls (list '+ '* '&))
;
;'---------------
;(newline)
;'(~~ bb)
(~~ bb)
;
;'---------------
;(newline)
;'(~~ ~ trois)
(~~ ~ trois)
;
;'---------------
;(newline)
;'(~~ a b (+ 1 2))
(~~ a b (+ 1 2))
;
;'---------------
;(newline)
;'(~~ ~@ ls)
(~~ ~@ ls)
;
;'---------------
;(newline)
;'(~~ ~ b ~ c (a b c))
(~~ ~ b ~ c (a b c))

;'---------------
;(newline)
;'(~~ ~@ ls ~ b ~ c 1)
;(~~ ~@ ls ~ b ~ c 1)
;
;'---------------
;(newline)
;'(~~ x b ~ b y ~ (+ trois 5))
;(~~ x b ~ b y ~ (+ trois 5))
;'---------------
;(newline)
;'(~~ 3 ~@ ls ~@ (range 5) 12)
;(~~ 3 ~@ ls ~@ (range 5) 12)
