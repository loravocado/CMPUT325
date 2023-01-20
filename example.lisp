; Examples of dealing with nested lists
                                       
; Example 1. Given a nested list of numbers, compute the sum

(defun xsum (L)
     (if (null L)
         0
         (if (atom L)
             L
             (+ (xsum (car L)) (xsum (cdr L))))))



; Example 2. Given a nested list L, replace any atom E by R, e.g.
;     (xreplace '(((x p) (x) x q t)) 'x 5)  => (((5 p) (5) 5 q t))

(defun xreplace (L E R)
    (cond
          ((null L) nil)
          ((atom L) (if (eq L E) R L))
          (t (cons (xreplace (car L) E R)
                   (xreplace (cdr L) E R)))))


; consider the definition below. You won't get syntax error but a runtime error
; in call like

;           (wrong-replace1 '(((x p) (x) x q t)) 'x 5)
;
; Why? 

(defun wrong-replace1 (L E R)
     (cond
          ((null L) nil)
          ((eq L E) R)
          (t (cons (wrong-replace1 (car L) E R)
                   (wrong-replace1 (cdr L) E R)))))


; Example 3. Further to Example 2, we apply a substitution to a given (possibly nested) list
; A substitution is represented by a list of pairs
;
; E.g., (sub '((x y) z 5 9 (4 (y))) '((x 1) (y 2) (z 3)))
;        ==> ((1 2) 3 5 9 (4 (2)))

(defun sub (L S)
  (cond ((null S) L)
        (t (sub (xreplace L (caar S) (cadar S)) (cdr S)))))

;You can set an atom bound to a long expression to save typing, can then use (eval test1) to run it
(set 'test1 (sub '((x y) z 5 9 (4 (y))) '((x 1) (y 2) (z 3))))