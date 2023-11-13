.586
.MODEL FLAT, C


; Funcions definides en C
printChar_C PROTO C, value:SDWORD
gotoxy_C PROTO C, value:SDWORD, value1: SDWORD
getch_C PROTO C


;Subrutines cridades des de C
public C posCurScreen, getMove, moveCursor, moveCursorContinuous, openCard, openCardContinuous, openPair, openPairsContinuous, open2Players, Play
                         
;Variables utilitzades - declarades en C
extern C row:DWORD, col: BYTE, rowScreen: DWORD, colScreen: DWORD, RowScreenIni: DWORD, ColScreenIni: DWORD 
extern C carac: BYTE, tecla: BYTE, gameCards: DWORD, indexMat: DWORD
extern C Board: BYTE, firstVal: DWORD, firstRow: DWORD, firstCol: BYTE, secondVal: DWORD, secondRow: DWORD, secondCol: BYTE
extern C Player: DWORD, Num_Card: DWORD, HitPair: DWORD
extern C pairsPlayer1: Dword, pairsPlayer2:DWORD, Winner: DWORD;


.code   
   
;;Macros que guardan y recuperan de la pila los registros de proposito general de la arquitectura de 32 bits de Intel    
Push_all macro
	
	push eax
   	push ebx
    push ecx
    push edx
    push esi
    push edi
endm


Pop_all macro

	pop edi
   	pop esi
   	pop edx
   	pop ecx
   	pop ebx
   	pop eax
endm
   
   



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Situar el cursor en una fila i una columna de la pantalla
; en funci� de la fila i columna indicats per les variables colScreen i rowScreen
; cridant a la funci� gotoxy_C.
;
; Variables utilitzades: 
; Cap
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxy proc
   push ebp
   mov  ebp, esp
   Push_all

   ; Quan cridem la funci� gotoxy_C(int row_num, int col_num) des d'assemblador 
   ; els par�metres s'han de passar per la pila
      
   mov eax, [colScreen]
   push eax
   mov eax, [rowScreen]
   push eax
   call gotoxy_C
   pop eax
   pop eax 
   
   Pop_all

   mov esp, ebp
   pop ebp
   ret
gotoxy endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar un car�cter, guardat a la variable carac
; en la pantalla en la posici� on est� el cursor,  
; cridant a la funci� printChar_C.
; 
; Variables utilitzades: 
; carac : variable on est� emmagatzemat el caracter a treure per pantalla
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printch proc
   push ebp
   mov  ebp, esp
   ;guardem l'estat dels registres del processador perqu�
   ;les funcions de C no mantenen l'estat dels registres.
   
   
   Push_all
   

   ; Quan cridem la funci�  printch_C(char c) des d'assemblador, 
   ; el par�metre (carac) s'ha de passar per la pila.
 
   xor eax,eax
   mov  al, [carac]
   push eax 
   call printChar_C
 
   pop eax
   Pop_all

   mov esp, ebp
   pop ebp
   ret
printch endp
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Llegir un car�cter de teclat   
; cridant a la funci� getch_C
; i deixar-lo a la variable tecla.
;
; Variables utilitzades: 
; carac2 : Variable on s'emmagatzema el caracter llegit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getch proc
   push ebp
   mov  ebp, esp
    
   ;push eax
   Push_all

   call getch_C
   
   mov [tecla],al
   
   ;pop eax
   Pop_all

   mov esp, ebp
   pop ebp
   ret
getch endp




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Posicionar el cursor a la pantalla, dins el tauler, en funci� de
; les variables row (int) i col (char), a partir dels
; valors de les variables RowScreenIni i ColScreenIni.
; Primer cal restar 1 a row (fila) per a que quedi entre 0 i 4
; i convertir el char de la columna (A..D) a un n�mero entre 0 i 3.
; Per calcular la posici� del cursor a pantalla (rowScreen) i 
; (colScreen) utilitzar aquestes f�rmules:
;            rowScreen=rowScreenIni+(row*2)
;            colScreen=colScreenIni+(col*4)
; Per a posicionar el cursor a la pantalla cridar a la subrutina gotoxy 
; que us donem implementada
;
; Variables utilitzades:	
;	row       : fila per a accedir a la matriu sea
;	col       : columna per a accedir a la matriu sea
;	rowScreen : fila on volem posicionar el cursor a la pantalla.
;	colScreen : columna on volem posicionar el cursor a la pantalla.
;	rowScreenIni : fila de la primera posici� de la matriu a la pantalla.
;	colScreenIni : columna de la primera posici� de la matriu a la pantalla.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
posCurScreen proc
    push ebp
	mov  ebp, esp




	mov esp, ebp
	pop ebp
	ret

posCurScreen endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Llegir un car�cter de teclat cridant a la subrutina que us donem implementada getch.
; Verificar que el car�cter introdu�t es troba entre els car�cters �i� i �l�, 
; o b� correspon a les tecles espai � � o �s�, i deixar-lo a la variable tecla.
; Si la tecla pitjada no correspon a cap de les tecles permeses, 
; espera que pitgem una de les tecles permeses.
;
; Variables utilitzades:
; tecla : variable on s�emmagatzema el car�cter corresponent a la tecla pitjada
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getMove proc
   push ebp
   mov  ebp, esp




   mov esp, ebp
   pop ebp
   ret

getMove endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Cridar a la subrutina getMove per a llegir una tecla
; Actualitzar les variables (row) i (col) en funci� de
; la tecla pitjada que tenim a la variable (tecla) 
; (i: amunt, j:esquerra, k:avall, l:dreta).
; Comprovar que no sortim del tauler, 
; (row) i (col) nom�s poden 
; prendre els valors [1..5] i [A..D], respectivament. 
; Si al fer el moviment es surt del tauler, no fer el moviment.
; Posicionar el cursor a la nova posici� del tauler cridant a la subrutina posCurScreen
;
; Variables utilitzades:
; tecla : car�cter llegit de teclat
; �i�: amunt, �j�:esquerra, �k�:avall, �l�:dreta 
; row : fila del cursor a la matriu gameCards.
; col : columna del cursor a la matriu gameCards.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursor proc
   push ebp
   mov  ebp, esp 




   mov esp, ebp
   pop ebp
   ret

moveCursor endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment continu
; del cursor fins que pitgem �s� o � espai � �
; S�ha d�anar cridant a la subrutina moveCursor
;
; Variables utilitzades:
; tecla: variable on s�emmagatzema el car�cter llegit
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursorContinuous proc
	push ebp
	mov  ebp, esp




	mov esp, ebp
	pop ebp
	ret

moveCursorContinuous endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina serveix per a poder accedir a les components de la matriu
; i poder obrir les caselles
; Calcular l��ndex per a accedir a la matriu gameCards en assemblador.
; gameCards[row][col] en C, �es [gameCards+indexMat] en assemblador.
; on indexMat = (row*4 + col (convertida a n�mero))*4 .
;
; Variables utilitzades:
; row: fila per a accedir a la matriu gameCards
; col: columna per a accedir a la matriu gameCards
; indexMat: �ndex per a accedir a la matriu gameCards
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calcIndex proc
	push ebp
	mov  ebp, esp
	



	mov esp, ebp
	pop ebp
	ret

calcIndex endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; S�ha de cridar a movCursorContinuous per a triar la casella desitjada.
; Un cop som a la casella desitjada premem al tecla � � (espai per a veure el contingut)
; Calcular la posici� de la matriu corresponent a la
; posici� que ocupa el cursor a la pantalla, cridant a la subrutina calcIndexP1. 
; Mostrar el contingut de la casella corresponent a la posici� del cursor al tauler.
; Considerar que el valor de la matriu �s un  int (entre 0 i 9)
; que s�ha de �convertir� al codi ASCII corresponent. 
;
; Variables utilitzades:
; tecla: variable on s�emmagatzema el car�cter llegit
; row : fila per a accedir a la matriu gameCards
; col : columna per a accedir a la matriu gameCards
; indexMat : �ndex per a accedir a la matriu gameCards 
; gameCards : matriu 5x4 on tenim els valors de les cartes.
; carac : car�cter per a escriure a pantalla.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
openCard proc
	push ebp
	mov  ebp, esp





	mov esp, ebp
	pop ebp
	ret

openCard endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; S�ha d'anar cridant a openCard fins que pitgem la tecla 's'
;
; Variables utilitzades:
; tecla: variable on s�emmagatzema el car�cter llegit
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
openCardContinuous proc
	push ebp
	mov  ebp, esp




	mov esp, ebp
	pop ebp
	ret

openCardContinuous endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Posicionar el cursor a la posici� 3,30 de la pantalla cridant a la subturina gotoxy
; Mostrar el valor de la variable Num_Card (1 o 2)
; Posicionar el cursor a la posici� 3,41 de la pantalla cridant a la subrutina gotoxy
; Mostrar el valor de la variable Player (1 o 2)
; Posicionar el cursor al taulell de joc i moure�l de forma continua fins que pitgem �s� o � � 
; Quan pitgem � �, obrim la casella (comprovar que no est� oberta i marcar-la com oberta)
; Tornar a moure el cursor de forma continua fins que pitgem �s� o � �
; Quan pitgem � �, obrim la casella (comprovar que no est� oberta i marcar-la com oberta)
; Comprovar si els valors de les dues caselles coincideixen. Si coincideixen, posar un 1 a HitPair.
; Si no coincideixen, tancar les dues caselles i desmarcar-les com a obertes.
;
; Variables utilitzades:
; Num_Card: Variable que indica si estem obrint la primera o la segona casella de la parella.
; carac : car�cter a mostrar per pantalla
; row : fila del cursor a la matriu gameCards o Board.
; col : columna del cursor a la matriu gameCards o Board.
; rowScreen: Fila de la pantalla on volem posicionar el cursor.
; colScreen: Columna de la pantalla on volem posicionar el cursor.
; indexMat: �ndex per accedir a la posici� de la matriu.
; gameCards: Matriu amb els valors de les caselles del tauler.
; Board: Matriu que indica si la casella est� oberta o no.
; firstVal, firstRow, firstCol: Dades relatives a la primera casella de la parella.
; secondVal, secondRow, secondCol: Dades relatives a la segona casella de la parella.
; Player: Indica el jugador al que li correspon el torn.
; HitPair: Variable que indica si s�ha fet una parella (0 No parell � 1 Parella)
; tecla: Codi ascii de la tecla pitjada.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
openPair proc
	push ebp
	mov  ebp, esp






	mov esp, ebp
	pop ebp
	ret
openPair endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina ha d�anar cridant a la subrutina anterior OpenPair,
; fins que pitgem la tecla �s�
;
; Variables utilitzades:
; tecla: Codi ascii de la tecla pitjada.

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
openPairsContinuous proc
	push ebp
	mov  ebp, esp




	mov esp, ebp
	pop ebp
	ret

openPairsContinuous endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Posicionar el cursor a la posici� 3,50 de la pantalla cridant a la subturina gotoxy
; Mostrar el valor de la variable pairsPlayer1 i mostrar les parelles aconseguides pel jugador 1.
; Posicionar el cursor a la posici� 3,57 de la pantalla cridant a la subturina gotoxy
; Mostrar el valor de la variable pairsPlayer2 i mostrar les parelles aconseguides pel jugador 2.
; Comen�a jugant el jugador 1 i cridem a openPair. 
; Mentre aconsegueixi parelles i no pitgi �s�
; seguir� jugant i s�anir� actualitzant el comptador de parelles
; Si no aconsegueix parella, el torn passa al jugador 2 que cridar� a openPair
; Mentre aconsegueixi parelles i no pitgi �s�
; seguir� jugant i s�anir� actualitzant el comptador de parelles
;
; Variables utilitzades:
; carac : car�cter a mostrar per pantalla
; rowScreen: Fila de la pantalla on volem posicionar el cursor.
; colScreen: Columna de la pantalla on volem posicionar el cursor.
; Player: Indica el jugador que te el torn.
; pairsPlayer1: Parelles aconseguides pel jugador 1
; pairsPlayer2: Parelles aconseguides pel jugador 2
; HitPair: Indica si s�ha aconseguit parella o no en una jugada
; tecla: Codi ascii de la tecla pitjada.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
open2Players proc
	push ebp
	mov  ebp, esp




	mov esp, ebp
	pop ebp
	ret

open2Players endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina Play anir� cridant a la subrutina open2Players
; mentre no pitgem �s� i queden parelles per a descobrir. 
; Ha de posar a la variable Winner el jugador (1 o 2) que ha fet m�s parelles. 
; Si han fet les mateixes parelles, 
; ha de posar un 0. 
;
; Variables utilitzades:
; tecla: Codi ascii de la tecla pitjada.
; pairsPlayer1: Nombre de parelles aconseguides pel jugador 1
; pairsPlayer2: Nombre de parelles aconseguides pel jugador 2
; Winner: Jugador que ha aconseguit m�s parelles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Play proc
	push ebp
	mov  ebp, esp




	mov esp, ebp
	pop ebp
	ret

Play endp

END