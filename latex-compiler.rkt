#lang racket

(require rackunit)
(require "utility.rkt")

(define (latex-form-normalize form)
  (cond [(< (length form) 3)
         (latex-form-normalize (append form '(())))]
        [else (let ([arguments (list-ref form 1)]
                    [options (list-ref form 2)])
                (cond [(not (list? arguments))
                       (latex-form-normalize (list-set form 1 (list arguments)))]
                      [(not (list? options))
                       (latex-form-normalize (list-set form 2 (list options)))]
                      [else
                       form]))]))

(check-equal? (latex-form-normalize '(a b c)) '(a (b) (c)))
(check-equal? (latex-form-normalize '(a)) '(a () ()))
(check-equal? (latex-form-normalize '(a (b))) '(a (b) ()))
(check-equal? (latex-form-normalize '(a b)) '(a (b) ()))                     

(define (compile-latex-form form)
  (match-define (list name arguments options) (latex-form-normalize form))
  (define (into-string-or-recurse option-or-argument)
    (format "~a" (if (list? option-or-argument)
                     (compile-latex-form option-or-argument)
                     option-or-argument)))
  (define option-string (if (null? options)
                            ""
                            (string-join (map into-string-or-recurse options)
                                         ", "
                                         #:before-first "["
                                         #:after-last "]")))
  (define argument-string (if (null? arguments)
                              ""
                              (string-join (map into-string-or-recurse arguments)
                                           "}{"
                                           #:before-first "{"
                                           #:after-last "}")))
  (format "\\~a~a~a" name option-string argument-string))

(check-equal? (compile-latex-form '(documentstyle (class) (11pt twoside)))
              "\\documentstyle[11pt, twoside]{class}")

(define (compile-latex-forms forms)
  (string-join (map (lambda (form)
                      (cond [(list? form)
                             (compile-latex-form form)]
                            [(string? form)
                             form]))
                    forms)
               "\n" #:after-last "\n"))

(display (compile-latex-forms '((documentstyle article (11pt epsfig))
                                ;TODO
                                (input testpoint)
                                (begin document)
                                ;; (change to appropriate class and semester)
                                "26L-04 Spring 1999"
                                ;; (change to appropriate quiz type and date,)
                                "Lab Quiz XX.XX.99"
                                (hspace (1.9in Name: (underline ((hspace 2.5in)))))
                                (vspace 2pc)
                                ;; (modify rules, time, points as appropriate)
                                "Show all work clearly and in order, and circle your final answers.
Justify your answers algebraically whenever possible; when you do use
your calculator, sketch all the relevant graphs and write down all
relevant mathematics. You have 25 minutes to take this 25 points quiz."
                                (vspace 2pc)
                                ;; Problem
                                (begin (problem 5))
                                "PROBLEM ONE"
                                (vfill)
                                (end problem)
                                ;; Problem
                                (begin (problem 10))
                                "PROBLEM TWO"
                                (vfill)
                                (end problem)
                                ;; Problem
                                (begin (problem 10))
                                "PROBLEM THREE"
                                (vfill)
                                (end problem)
                                ;; End Problems
                                (showpoints)
                                (end document))))
                       


  
  