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
; Fun��o main()
Start  

; Comece o c�digo aqui <======================================================
	LDR R0,=TEXTO ;; Pega o endereco do primeiro byte
	LDR R2,=INICIAL

REPETIR
	LDRB R1,[R0],#1;;armazena o dado de endereco r0 no registrador r1, incrementa r0 em 1
	STRB R1,[R2],#1;;coloca o dado 
	CMP R1,#0
	BEQ FIM
	B REPETIR
FIM

;;Funcao de ordenacao

	MOV R6,#4;;indice do loop 1
	
LOOP1
	MOV R7,#4;;indice do loop 2
	CMP R6,#0
	BEQ FIM2;;TESTA INIDICE DO LOOP1
	SUB R6,#1;;Decrementa o indice 1
LOOP2	
	LDR R2,=INICIAL;;Pega o endereco inicial dos dados na ram
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
	BHI LOOP3;;se r0 for maior que r1 repete o loop 3 sem trocar
	SUB R2,#1;;Decrementa o endereco base da ram
	STRB R0,[R2,#1];;troca os valores de posicao
	STRB R1,[R2];;troca os valores de posicao
	ADD R2,#1;;Incrementa o endereco base da ram
	B LOOP3
FIM2
	
;;loop teste

	MOV R0,#1
WHILE
	ADD R0,#1
	CMP R0,#10
	BEQ DONE
	B WHILE
DONE
	NOP

	
TEXTO DCB 1,2,3,4,0
	ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
