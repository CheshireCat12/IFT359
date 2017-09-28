#lang racket

; Chea Dany 17 133 040
; Gillioz Anthony 17 133 031

(provide intersection3)
(require (file "codedesdiapositives.rkt"))

(define intersection3  
  (λ (ls1 ls2 ls3)
    (cond
      [(null? ls1)'()]
      [(null? ls2)'()]
      [(null? ls3)'()]
     
      [else
       (cond
         [(gt (car ls1) (car ls2)) (intersection3  ls1 (cdr ls2) ls3)]
         [else
          (cond
            [(gt (car ls2) (car ls1)) (intersection3 (cdr ls1) ls2 ls3)]
            [else
             (cond
               [(gt (car ls1) (car ls3))(intersection3 ls1 ls2 (cdr ls3))]
               [else
                (cond
                  [(gt (car ls3) (car ls1))(intersection3 (cdr ls1) (cdr ls2) ls3)]
                  [else
                   (cond
                     [(equal? (car ls1) (car ls3))(cons (car ls1) (intersection3(cdr ls1)(cdr ls2)(cdr ls3)))]
                     )
                   ]
                  )
                ]
               )
             ]
            )
          ]
         )        
       ]
      )
    ))

