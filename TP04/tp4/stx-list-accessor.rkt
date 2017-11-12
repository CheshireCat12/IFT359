#lang racket

(require syntax/stx)
(require (for-syntax syntax/stx))
; le précédent est utile si on veut tester à la phase 0
(provide (all-defined-out)
         (all-from-out syntax/stx))

;; prendre note stx-cdr retourne une liste et non un objets syntaxique encapsulant une liste


(define stx-caar
  (λ (p)
    (stx-car (stx-car p))))

(define stx-cddr
  (λ (p)
    (stx-cdr (stx-cdr p))))

(define stx-cadr
  (λ (p)
    (stx-car (stx-cdr p))))

(define stx-cdar
  (λ (p)
    (stx-cdr (stx-car p))))

(define stx-cdddr
  (λ (p)
    (stx-cdr (stx-cdr (stx-cdr p)))))

(define stx-cddar
  (λ (p)
    (stx-cdr (stx-cdr (stx-car p)))))

(define stx-cdadr
  (λ (p)
    (stx-cdr (stx-car (stx-cdr p)))))

(define stx-caddr
  (λ (p)
    (stx-car (stx-cdr (stx-cdr p)))))

(define stx-caaddr
  (λ (p)
    (stx-car (stx-car (stx-cdr (stx-cdr p))))))

(define stx-caadr
  (λ (p)
    (stx-car (stx-car (stx-cdr p)))))

(define stx-cadar
  (λ (p)
    (stx-car (stx-cdr (stx-car p)))))

(define stx-cdaar
  (λ (p)
    (stx-cdr (stx-car (stx-car p)))))

(define stx-caaar
  (λ (p)
    (stx-car (stx-car (stx-car p)))))

(define stx-cadadr
  (λ (p)
    (stx-car (stx-cdr  (stx-car   (stx-cdr p))))))


(define stx-cadaddr
  (λ (p)
    (stx-car (stx-cdr  (stx-car  (stx-cdr  (stx-cdr p)))))))

(define stx-cddaddr
  (λ (p)
    (stx-cdr (stx-cdr  (stx-car  (stx-cdr  (stx-cdr p)))))))
