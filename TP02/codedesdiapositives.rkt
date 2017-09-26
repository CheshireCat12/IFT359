#lang racket
(provide (all-defined-out))

(define atom? 
  (λ (x) 
    (or (boolean? x) (number? x) (char? x) (symbol?  x))))

(define plus
  (λ (n m)
    (cond 
      [(zero? m) n]
      [else (add1 (plus n (sub1 m)))])))

(define mult
  (λ (n m)
    (cond 
      [(zero? m) 0]
      [else (plus n (mult n (sub1 m)))])))

(define gt
  (λ (n m)
    (cond [(zero? n) #f]
          [(zero? m) #t]
          [else (gt (sub1 n) 
                    (sub1 m))])))

(define length
  (λ (lat) 
    (cond 
      [(null? lat) 0]
      [else (add1 (length (cdr lat)))])))


(define lat?
  (λ (lat)
    (cond 
      [(null? lat) #t]
      [(atom? (car lat)) (lat? (cdr lat))]
      [else #f])))


(define contient?
  (λ (a lat)
    (cond [(null? lat) #f]
          [(eq? a (car lat)) #t]
          [else (contient? a (cdr lat))])))

(define remove
  (λ (a lat)
    (cond 
      [(null? lat) '()]
      [(eq? a (car lat)) (cdr lat)]
      [else (cons (car lat) 
                  (remove a (cdr lat)))])))

(define somme
  (λ (t)  
    (cond [(null? t) 0]
          [else (plus (car t) 
                      (somme (cdr t)))])))

(define compte-atomes 
  (λ (s-exp)
    (cond 
      [(null? s-exp) 0]
      [(atom? s-exp) 1]
      [else (plus 
             (compte-atomes (car s-exp))  
             (compte-atomes (cdr s-exp)))])))

(define occur
  (λ (e arbre)
    (cond
      [(null? arbre) 0]
      [(atom? arbre)
       (cond 
         [(eq? e arbre) 1]
         [else 0])]
      [else 
       (plus (occur e (car arbre))       		 
             (occur e (cdr arbre)))])))

(define eval-exp-diapo
 (λ (exp)
  (cond 
   [(null? exp) 0]
   [(atom? exp) exp]
   [(eq? (car exp) '+) 
    (plus (eval-exp-diapo (cadr exp))
          (eval-exp-diapo (caddr exp)))]
   [else 'exp-invalide])))







