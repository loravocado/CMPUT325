;QUESTION 1
;What the function does: It counts the amount of times E occurs in a L
;How it works: It first checks if L is an atom. If it is an atom, it then checks if L is the element E we are looking for. If it is, we return 1, otherwise, we return 0. If L is not an atom, we recursively check the first element of L. Then we sum up the 0's and 1's that are returned recursively to get the sum of how many times E occurs in L

(defun occurs (E L)
    (if (atom L)
        (if (eq E L) 1 0)
        (+ (occurs E (car L)) (occurs E (cdr L)))))


;QUESTION 2
;What the function does: It flattens the list so that a list of atoms is returned with all atoms that are in x appearing in the result and in the same order.
;How it works: Base case: when x is null (at the end of a list). It checks if the first item in x is an atom. If it is, it puts it into a list with the element that returns from recursively calling the rest of xflatten x. Basically this results in a chain of cons such that xflatten '(A (B) C) results in (cons A (cons B (cons C '()))) which equals (A B C). If the first element of x is not an atom, we can assume it is a list and then recursively call this function on the first element of the list and the rest of the elements from the list.
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
;What the function does: It removes duplicates from the list and returns the rest of the list without duplicates
;How it works: It checks if the first element of x exists in the rest of the elements of x. If it does, then it calles remove-duplicate with the rest of the elements in x without the first element. This is how we remove a duplicate element. Otherwise if it doesn't exist in the rest of x, we just move on to check the next element.

(defun remove-duplicate (x) 
    (if (null x)
        x
        (if (eq 0 (occurs (car x) (cdr x)))
            (cons (car x) (remove-duplicate(cdr x)))
            (remove-duplicate(cdr x))
        )
    )
)

;QUESTION 4A
;What the function does: It returns one list that has the elements from L2 and L1 combined but alternating -- L1 = '(A B C) and L2 = '(D E F), mix(L1 L2) = '(D A E B F C)
;How it works: If there are no elements left in L1, it returns L2 and if no elements are left in L2, it returns L1. If both lists contain items, it recursively calls the first element of L2 to be combined with the first element of L1 until either lists run out of items/

(defun mix (L1 L2)
    (if (null L1) 
        L2
        (if (null L2) 
            L1
            (cons (car L2) (cons (car L1) (mix (cdr L1) (cdr L2)))))))


;QUESTION 4B
(defun split (L)
    (list (get_even L) (get_odd L)))

(defun get_even (L)
    (if (and (car (cdr L)))
        (cons (car (cdr L)) (get_even (cdr (cdr L))))))

(defun get_odd (L)
    (if (and (car L))
        (cons (car L) (get_odd (cdr (cdr L))))))

;QUESTION 5


;QUESTION 6
(defun substitute0 (A E L)
    (if L 
        (cond
            ((and (atom (car L)) (eq A (car L))) (cons E (substitute0 A E (cdr L))))
            ((atom (car L)) (cons (car L) (substitute0 A E (cdr L))))
            (t (cons (substitute0 A E (car L)) (substitute0 A E (cdr L))))
        )
    )
)

;QUESTION 7

;; (defun return_connection (x L)
;;     (if (> (occurs x L) 0)
;;         (if (eq (car L) x)
;;             (car (cdr L))
;;             (car L)
;;         )
;;     )
;; )

;; (defun reached (x L)
;;     (if (return_connection x (car L))
;;         (cons (return_connection x (car L)) (reached x (cdr L)))
;;     )
;; )

(defun is_equal_to (L0 L1 L2)
    (if (occurs L0 (car L1))
        (car L2)
        (if (eq x (car L2))
            (car L1)
        )
    )
)

(defun combine_list (x L1 L2)
    (if L1  
        (if (is_equal_to x L1 L2)
            (cons (is_equal_to x L1 L2) (combine_list x (cdr L1) (cdr L2)))
            (combine_list x (cdr L1) (cdr L2))
        )
    )
)

(defun reached (x L)
    (combine_list x (car (split (xflatten L))) (car (cdr (split (xflatten L)))))
)
