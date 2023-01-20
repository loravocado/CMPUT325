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

