8 задание [7 баллов]
Недетерминированный конечный автомат задан в виде таблицы переходов. Напишите программу, которая считает эту таблицу из файла и с помощью алгоритма детерминизации построит эквивалентный детерминированный автомат.
a.txt - входной автомат
b.txt - выходной автомат
Структура файла:

        a     b     c
~(A)  B,A    -     C
B   C,A    -     -
....................
(C)   -     C     B

В первой строке задается алфавит, в остальных сначала указывается состояние, а затем переходы.
"~" означает начальное состояние (можно не ставить, тогда начальным состоянием будет первое состояние).
"(..)" означает финальное состояние.
" " обязательно нужно ставить, как границы между состояниями и буквами алфавита.
"-" означает, что нет перехода.