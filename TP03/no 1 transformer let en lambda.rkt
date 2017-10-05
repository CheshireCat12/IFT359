#lang racket

; Chea Dany 17 133 040
; Gillioz Anthony 17 133 031

(define f (λ (a b c) (list a b c)))
(define g (λ (a b c) (append a b c)))
(define zz #t)

(displayln "\nexécution du numéro 1 a)\n")

(let ([f (λ (u v w)
           (g u v w))]
      [g (λ (x y z)
           (cond [zz 
                  (set! zz (not zz))
                  (f x y '(zz))]
                 [else 
                  'ouf]))])
  (list (f '(i)'(j)'(k)) (g '(e)'(f)'(g))))
(set! zz #t)
;****** Donnez votre réponse du # 1 a ci-dessous **********
((λ(f g)
   (list (f '(i)'(j)'(k)) (g '(e)'(f)'(g))))
 (λ (u v w)
   (g u v w))
 (λ (x y z)
   (cond [zz 
          (set! zz (not zz))
          (f x y '(zz))]
         [else 
          'ouf])))
;******               fin du # 1 a               **********

(displayln "\nexécution du numéro 1 b)\n")

(set! zz #t)
(let* ([f (λ (u v w)
            (g u v w))]
       [g (λ (x y z)
            (cond [zz 
                   (set! zz (not zz))
                   (f x y '(zz))]
                  [else 
                   'ouf]))])
  (list (f '(i)'(j)'(k)) (g '(e)'(f)'(g))))

(set! zz #t)

;****** Donnez votre réponse du # 1 b ci-dessous **********
((λ(f) ((λ(g) (list (f '(i)'(j)'(k)) (g '(e)'(f)'(g))))
        (λ (x y z)
             (cond [zz 
                    (set! zz (not zz))
                    (f x y '(zz))]
                   [else 
                    'ouf]))))
 (λ (u v w)
           (g u v w)))



;******               fin du # 1 b               **********


(displayln "\nexécution du numéro 1 c)\n")

(set! zz #t)
(letrec ([f (λ (u v w)
              (g u v w))]
         [g (λ (x y z)
              (cond [zz 
                     (set! zz (not zz))
                     (f x y '(zz))]
                    [else 
                     'ouf]))])
  (list (f '(i)'(j)'(k)) (g '(e)'(f)'(g))))

(set! zz #t)
;****** Donnez votre réponse du # 1 c ci-dessous **********
((λ(f g) (set! f (λ (u v w)
            (g u v w)))
  (set! g (λ (x y z)
            (cond [zz 
                   (set! zz (not zz))
                   (f x y '(zz))]
                  [else 
                   'ouf])))
  (list (f '(i)'(j)'(k)) (g '(e)'(f)'(g)))) (void) (void))


;******               fin du # 1 c               **********
