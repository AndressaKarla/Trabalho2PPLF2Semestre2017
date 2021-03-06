﻿:- use_module(library(plunit)).

%% ------------------- VERSÃO GERAR E TESTAR COM PERMUTAÇÕES -------------------

%% rainhas_p(Q, N) is nondet
%  Verdadeiro se Q é uma solução de tamanho N com N rainhas.
%  Este predicado constrói as possíves soluções do N-rainhas.
%  Exemplo:
%  ?- rainhas_p(Q, 4).
%  Q = [3, 1, 4, 2];
%  Q = [2, 4, 1, 3];
%  false.

:- begin_tests(rainhas_p).

test(t1, [nondet]):- rainhas_p(_, _).
test(t2, [nondet], [fail]):- rainhas_p([], _).
test(t3, [nondet], [fail]):- rainhas_p([], 1).
test(t4, [nondet], Q == [1]):- rainhas_p(Q, 1).
test(t5, [nondet], [fail]):- rainhas_p(_, 2).
test(t6, [nondet], [fail]):- rainhas_p(_, 3).
test(t7, [nondet], Q == [3, 1, 4, 2]):- rainhas_p(Q, 4).
test(t8, [nondet]):- rainhas_p([5, 2, 6, 1, 7, 4, 8, 3], 8).

:- end_tests(rainhas_p).

rainhas_p(Q, N) :-
	sequencia(1, N, R),
	permutacao(R, Q),
	solucao(Q).

%% sequencia(+I, +F, ?S) is semidet
%  Verdadeiro se S é uma lista com os números inteiros
%  entre I e F (inclusive)
%  Exemplo:
%  ?- sequencia(1, 4, [1, 2, 3, 4]).
%  true.

:- begin_tests(sequencia).

test(t9):- sequencia(_, _,_).
test(t10, [fail]):- sequencia(_, _, []).
test(t11):- sequencia(1, 1, [1]).
test(t12):- sequencia(1, 2, [1, 2]).
test(t13):- sequencia(1, 4, [1, 2, 3, 4]).
test(t14, [fail]):- sequencia(1, 0, _).
test(t15, S == [1, 2, 3, 4, 5, 6, 7, 8]):- sequencia(1, 8, S).

:- end_tests(sequencia).

sequencia(I, F, S) :-
	aux_sequencia(I, F, S).

aux_sequencia(I,I,[I]):-!.

aux_sequencia(I,F,[I|LS]):-
	I < F,
	I1 is I + 1,
	aux_sequencia(I1,F,LS).

%% permutacao(?L, ?P) is nondet
%  Verdadeiro se P é uma permutação da lista L
%  Exemplo1:
%  ?- permutacao([1, 2, 3, 4], P).
%  P = [1, 2, 3, 4] ;
%  P = [2, 1, 3, 4] ;
%  P = [2, 3, 1, 4] ;
%  ...
%
%  Exemplo2:
%  ?- permutacao([1, 2, 3, 4], [3, 1, 4, 2]).
%  true.

:- begin_tests(permutacao).

test(t16, [nondet]):- permutacao(_, _).
test(t17, [nondet],[fail]):- permutacao(_, []).
test(t18, [nondet]):- permutacao([1], [1]).
test(t19, [nondet]):- permutacao([1, 2, 3, 4], [3, 1, 4, 2]).

:- end_tests(permutacao).

permutacao(L, P):-
	aux_permutacao(L,P).

aux_permutacao([], []).

aux_permutacao([L | LS], P):-
	permutacao(LS, L1),
	insercao(L, L1, P).

%% ---- FUNÇÕES AUXILIARES PARA PERMUTAÇÃO ----  %%

% insercao(?X, ?L, ?L1) is nondet
% Verdadeiro se ao inserir um elemento X em algum lugar de uma lista L
% resulta em uma nova lista L1, com o elemento X
% inserido na posição desejada
% Exemplo:
%  ?- insercao(3, [1, 4, 2], L).
%  L = [3, 1, 4, 2] ;
%  L = [1, 3, 4, 2] ;
%  L = [1, 4, 3, 2] ;
%  L = [1, 4, 2, 3] ;
%  false.

insercao(X, L, L1):-
	remocao(X, L1, L).

% remocao(?X, ?L, ?L1) is nondet
% Verdadeiro se a lista L1 é a lista L com o elemento X removido
% Exemplo:
%  ?- insercao(3, [1, 4, 2], L).
%  L = [3, 1, 4, 2] ;
%  L = [1, 3, 4, 2] ;
%  L = [1, 4, 3, 2] ;
%  L = [1, 4, 2, 3] ;
%  false.

remocao(X, [X | L1], L1).
remocao(X, [Y | L1], [Y | L]):-
remocao(X, L1, L).

%%  ------------------------------------------  %%


%% solucao(+Q) is semidet
%  Verdadeiro se Q é uma solução N-rainhas
%  Este predicado apenas verifica se Q é uma solução, e não a constrói.
%  Exemplo:
%  ?- solucao([3, 1, 4, 2]).
%  true;
%  false.

:- begin_tests(solucao).

test(t20, [nondet]):- solucao(_).
test(t21):- solucao([]).
test(t22, [nondet]):- solucao([1]).
test(t23, [fail]):- solucao([1, 2]).
test(t24, [nondet]):- solucao([3, 1, 4, 2]).

:- end_tests(solucao).

solucao(Q):-
	aux_solucao(Q).

aux_solucao([]).

aux_solucao([Q|QS]) :-
	aux_solucao(QS),
	rainha_nao_ataca(Q, QS,1).

%% rainha_nao_ataca(+X, +Y, +INDICE) is det
%  Verdadeiro se há diferença entre os elementos da lista Y e o valor X
%  e o índice
%  Caso haja essa diferença, significa que não há ataque
%  entre as rainhas na diagonal
%  Exemplo:
%  ?- rainha_nao_ataca(4, [3, 1, 4, 2], 3).
%  true.
rainha_nao_ataca(_,[],_).

rainha_nao_ataca(X,[Y|YS], INDICE) :-
	Y-X =\= INDICE,
	X-Y =\= INDICE,
	INDICE1 is INDICE + 1,
	rainha_nao_ataca(X, YS, INDICE1).
