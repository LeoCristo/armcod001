; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>

; -------------------------------------------------------------------------------
INICIAL EQU 0x20000D00 ;endereco na ram
PRIMO   EQU 0x20000E00 ;N�meros primos da lista
; Fun��o main()
Start  

; Comece o c�digo aqui <======================================================
	LDR R0,=VETOR ;; Pega o endereco do primeiro byte
	LDR R2,=INICIAL
;;Funcao para a lista com os n�meros aleat�rios na posi��o INICIAL
REPETIR0
	LDRB R1,[R0],#1;;armazena o dado de endereco r0 no registrador r1, incrementa r0 em 1
	STRB R1,[R2],#1;;coloca o dado 
	CMP R1,#0
	BEQ FIM0
	B REPETIR0
FIM0

;Funcao para a lista com os n�meros primos na posi��o PRIMO
	LDR R0,=INICIAL
	LDR R2,=PRIMO
	MOV R9,#0;;Quantidade de n�meros primos
REPETIR1
	LDRB R1,[R0],#1;;armazena o dado de endereco r0 no registrador r1, incrementa r0 em 1
	CMP R1,#0
	BEQ FIM1
;;Testa se o n�mero � primo
	MOV R6,R1
	MOV R7,#1
	MOV R8,#0
TESTE
	CMP R7,R6
	BEQ ADICIONAR
	ADD R7,#1
	UDIV R5,R1,R7;;R5=R1/R7
	MLS R3,R5,R7,R6;;R3=R6-R5*R7
	CMP R3,#0
	BNE TESTE
	ADD R8,#1
	B TESTE
;;Fim do teste

;;Adiciona o n�mero na mem�ria
ADICIONAR
	CMP R8,#1
	BNE REPETIR1
	STRB R1,[R2],#1;;coloca o dado
	ADD R9,#1;;Armazena a quantidade de n�meros primos
	B REPETIR1
FIM1

;;Funcao de ordenacao
	SUB R9,#1
	MOV R6,R9;;indice do loop 1
	
LOOP1
	MOV R7,R9;;indice do loop 2
	CMP R6,#0
	BEQ FIM2;;TESTA INIDICE DO LOOP1
	SUB R6,#1;;Decrementa o indice 1
LOOP2	
	LDR R2,=PRIMO;;Pega o endereco inicial dos dados na ram
	CMP R7,#0
	BEQ LOOP1	
LOOP3
	CMP R7,#0
	BEQ LOOP1
	SUB R7,#1;;Decrementa o indice 2
	LDRB R0,[R2];;Pega o dado atual
	LDRB R1,[R2,#1];;pega o dado seguinte
	ADD R2,#1;;Incrementa o endereco base da ram
	CMP R0,R1;;Compara r0 e r1
	BLO LOOP3;;se r0 for menor que r1 repete o loop 3 sem trocar
	SUB R2,#1;;Decrementa o endereco base da ram
	STRB R0,[R2,#1];;troca os valores de posicao
	STRB R1,[R2];;troca os valores de posicao
	ADD R2,#1;;Incrementa o endereco base da ram
	B LOOP3
FIM2
	
	NOP

	
VETOR DCB 193,10,73,127,43,14,211,3,203,5,21,7,206,233,157,237,241,105,252,19,0;; O 0 indicca o fim da lista
	ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
