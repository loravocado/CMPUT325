;Helper function
;How it works: Checks if x has a connection in L and adds to L1 if it does
(defun iterate-list (L1 x original-x L original-L)
    (if (null L)
        L1
        ;Checks if the first element of L is the same as current x
        (let ((c (checker x (car L))))
            ;If checker returned an element, checker returned an element that's different from x, and current x and the returned element are not the same
            (if (and (not (eq original-x c)) (and c (not (eq c x))))
                ;Append L1 (our accumulator) with c the connection we found and recursively call the rest of the list with all the original information passed in. This is then appended with what is returned from rechecking the list for any new connections with the c connection we just found
                (append (iterate-list (append L1 (list c)) x original-x (cdr L) original-L) (iterate-list '() c original-x original-L original-L))
                ;otherwise it is not a connection and we should continue recursively calling with the rest of the list
                (iterate-list L1 x original-x (cdr L) original-L)
            )
        )
    )
)