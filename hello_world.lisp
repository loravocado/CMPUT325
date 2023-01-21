;QUESTION 1
;documentation

(defun occurs (E L)
    (if (atom L)
        (if (eq E L)
            1
            0
        )
        (+ (occurs E (car L)) (occurs E (cdr L)))
    )
)

;QUESTION 2
;documentation

(defun xflatten (x)
    (if (null x)
        '()
        (if (atom (car x))
            (cons (car x) (xflatten (cdr x)))
            (append (xflatten (car x)) (xflatten (cdr x)))
        )
    )
)

;QUESTION 3
;documentation

(defun check_exists (A B)
    (if (null B)
        nil
        (if (eq A (car B))
            t 
            (check_exists A (cdr B))
        )
    )
)

(defun remove-duplicate (x) 
    (if (null x)
        x
        (if (null (check_exists (car x) (cdr x)))
            (cons (car x) (remove-duplicate(cdr x)))
            (remove-duplicate(cdr x))
        )
    )
)

;QUESTION 4
;documentation