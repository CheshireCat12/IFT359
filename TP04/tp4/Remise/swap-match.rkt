#lang racket
(require (for-syntax racket/match
                     (file ".\\util\\stx-util.rkt")))
(define-syntax swap
  (λ (stx)
    (match (list (stx-cadr stx) (stx-caddr stx))
      [(list var1 var2)
       (let ([temp (datum->syntax stx (gensym 'temp))])
         (datum->syntax stx
                        `(let ([,temp ,var1])
                           (set! ,var1 ,var2)
                           (set! ,var2 ,temp))))])))

(define x 5)
(define y 10)

(swap-match x y)

x
y