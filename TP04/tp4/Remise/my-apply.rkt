#lang racket

(require (for-syntax (file "../stx-list-accessor.rkt")
                     racket/list))

(require racket/list)

(provide my-apply2)
(displayln "nom1, prénom1")
(displayln "nom2, prénom2")

(define-syntax my-apply2
  (λ (stx)
    (let ([operator (stx-cadr stx)]
          [reste (stx-cddr stx)])
      (displayln (syntax->datum stx))
      (cond
        [(stx-null? reste) (datum->syntax stx 0)]
        [(list? (syntax->datum (stx-car reste)))
         (let ([ls (stx->list (stx-car reste))])
           (if (symbol? (syntax->datum  (stx-car ls)))
              ;(displayln (syntax->datum  (stx-car ls)))
              (datum->syntax stx `(begin
                              (,operator ,(stx-cadr ls) (my-apply2 ,(stx-car ls) ,@(stx-cddr ls)) (my-apply2 ,operator ,(stx-cdr reste)))))
              ;(displayln (syntax->datum  (stx-caar (stx->list (stx-cdr (stx-car ls))))))
              ;(if (eq? (syntax->datum  (stx-car ls)) 'quote)
               ;   (displayln (syntax->datum  (stx-car ls)))
                ;  (displayln (syntax->datum  (stx-car ls))))
              (datum->syntax stx `(begin
                              (,operator ,(stx-caar (stx->list (stx-cdr (stx-car ls)))) (my-apply2 ,operator ,(stx-cadr (stx-car (stx->list (stx-cdr (stx-car ls)))))))))
           ));(displayln (syntax->datum (stx-cadr (stx-car (stx->list (stx-cdr (stx-car reste)))))))]
         ]
         ;(datum->syntax stx `(begin
          ;                    (,operator ,(stx-caar (stx->list (stx-cdr (stx-car reste)))) (my-apply2 ,operator ,(stx-cadr (stx-car (stx->list (stx-cdr (stx-car reste)))))))))]
        ;[(stx-list? (stx-car reste)) ;(if (eq? (syntax->datum (stx-car reste)) '+)
                                      ;   '()
                                         ;(displayln "toto")]
                                       ;  (datum->syntax stx `(begin
                                        ;                       (,operator ,(stx-car (stx->list (stx-car reste))) (my-apply2 ,operator ,@(stx-cdr (stx->list (stx-car reste))))))))]
        [else(datum->syntax stx `(begin
                                   (,operator ,(stx-car reste) (my-apply2 ,operator ,@(stx-cdr reste)))))]
        ))))
;'(apply + 1 2 3 '(4 5))
;(my-apply + 4 2 3)
(my-apply2 + 1 (+ 1 5) '(4 5))
;'(apply + '(4 5))(my-apply (list operator reste))
;(apply + '(4 5))