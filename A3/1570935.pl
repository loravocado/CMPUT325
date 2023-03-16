
% #Q1
% isMember(A, L): A is in list L
isMember(A, [A|_]).
isMember(A, [B|L]) :- A \== B, member(A, L).

% #setIntersect([a,b,c,d,e,g],[b,a,c,e,f,q],S).
setIntersect([], _, []).
setIntersect([A|L], L2, [A|L3]):- member(A, L2), setIntersect(L, L2, L3).
setIntersect([_|L], L2, L3):- setIntersect(L, L2, L3).

% #Q2
swap([], []).
swap([A, B | L], [B, A | R]) :- swap(L, R).
swap([A | L], [A | R]) :- swap(L, R).  

% #Q3

flatten([],[]).
flatten([A|L],[A|L1]) :- atomic(A), flatten(L,L1).
flatten([A|L],R) :- flatten(A,A1), flatten(L,L1), append(A1,L1,R).

filter(L, W, N, L1) :- flatten(L, L2), filter_list(L2, W, N, L1).

filter_list([], _, _, []).
filter_list([A | L], equal, N, [A | L1]) :- A == N, filter(L, equal, N, L1).
filter_list([A | L], greaterThan, N, [A | L1]) :- A > N, filter(L, greaterThan, N, L1).
filter_list([A | L], lessThan, N, [A | L1]) :- A < N, filter(L, lessThan, N, L1).

filter_list([_ | L], W, N, L1) :- filter(L, W, N, L1).

% #Q4

count_list(_, [], 0).
count_list(A, [B | L], C) :- A == B, count_list(A, L, C1), C1 is C + 1.
count_list(A, [_ | L], C) :- count_list(A, L, C).

