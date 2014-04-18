#lang racket

(require rackunit)

(provide sloppy-take
         sloppy-drop
         partition
         dict-join
         list-set)

(define (list-set lst n val)
  (append (take lst n)
          (cons val (drop lst (add1 n)))))

(check-equal? (list-set (range 3) 1 10) '(0 10 2))
(check-equal? (list-set (range 3) 0 10) '(10 1 2))
(check-equal? (list-set (range 3) 2 10) '(0 1 10))

(define (sloppy-take lst n)
  (if (<= n (length lst))
      (take lst n)
      lst))

(check-equal? (sloppy-take (range 4) 2) (range 2))
(check-equal? (sloppy-take (range 2) 4) (range 2))

(define (sloppy-drop lst n)
  (if (<= n (length lst))
      (drop lst n)
      '()))

(check-equal? (sloppy-drop (range 4) 2) '(2 3))
(check-equal? (sloppy-drop (range 2) 4) '())

(define (partition n lst)
  (if (null? lst)
      '()
      (cons (sloppy-take lst n)
            (partition n (sloppy-drop lst n)))))

(check-equal? (partition 2 (range 4)) '((0 1) (2 3)))
(check-equal? (partition 2 (range 3)) '((0 1) (2)))
  
(define (dict-join dict-1 dict-2)
  (append (filter (lambda (pair)
                    (dict-has-key? dict-2 (first pair)))
                  dict-2)
          dict-2))