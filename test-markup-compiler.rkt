#lang racket

(require "utility.rkt")

(define error-display-source-length 20) ; If source is displayed in an error it will only show this many characters.

(struct notes (table) #:transparent)

(define (notes-ref notes key)
  (dict-ref (notes-table notes) key))

(define (notes-join notes-1 notes-2)
  (notes (dict-join notes-1 notes-2)))

(define (extract-notes source-form)
  (apply append
         (map rest (filter (lambda (form)
                             (and (list? form)
                                  (eq? (first form) 'notes)))
                           source-form))))

(define (compile-notes form)
  (partition 2 form))

(struct challenge (question answers notes) #:transparent)

(define challenge-tags '(choice))

(define (extract-challenges source-form)
  (filter (compose (curryr member challenge-tags) first) source-form))

(define (compile-challenge source-form higher-notes)
  (define notes (notes-join higher-notes (compile-notes (extract-notes source-form))))
  (match-define (list 'choice (list 'q question-source-form) (list 'a answer-source-form)) source-form)
  (define normalized-answers (map (lambda (x)
                                    (if (list? x)
                                        x
                                        (list x #f)))
                                  answer-source-form))
  (challenge question-source-form
             normalized-answers
             notes))
  
(struct section (title sub-sections sub-challenges notes) #:transparent)

(define (extract-sections source-form)
  (filter (compose (curry eq? 'section) first) source-form))

(define (compile-section source-form higher-notes)
  (match source-form
    [(list 'section title body ...)
     (let ([notes (notes-join higher-notes
                              (compile-notes (extract-notes body)))])
       (section title
                (map (curryr compile-section notes) (extract-sections body))
                (map (curryr compile-challenge notes) (extract-challenges body))
                notes))]
    [_ (error (format "Invalid source form: ~a"
                      (substring (list->string source-form) 0 error-display-source-length)))]))
               
(define (compile-top rats-source top-level-notes)
  (compile-section rats-source top-level-notes))
