; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>

; -------------------------------------------------------------------------------
INICIAL EQU 0x20000D00 ;endereco na ram
PRIMO   EQU 0x20000E00 ;Números primos da lista
; Função main()
Start  

; Comece o código aqui <======================================================
	LDR R0,=TEXTO ;; Pega o endereco do primeiro byte
	LDR R2,=INICIAL
;;Funcao para a lista com os números aleatórios na posição INICIAL
REPETIR0
	LDRB R1,[R0],#1;;armazena o dado de endereco r0 no registrador r1, incrementa r0 em 1
	STRB R1,[R2],#1;;coloca o dado 
	CMP R1,#0
	BEQ FIM0
	B REPETIR0
FIM0

;Funcao para a lista com os números primos na posição PRIMO
	LDR R0,=INICIAL
	LDR R2,=PRIMO
REPETIR1
	LDRB R1,[R0],#1;;armazena o dado de endereco r0 no registrador r1, incrementa r0 em 1
	CMP R1,#0
	BEQ FIM1
;;Testa se o número é primo
	MOV R6,R1
	MOV R7,#1
	MOV R8,#0
TESTE
	CMP R7,R6
	BEQ ADICIONAR
	ADD R7,#1
	UDIV R5,R1,R7;;R2=R1/R7
	MLS R3,R5,R7,R6;;R3=R6-R5*R7
	CMP R3,#0
	BNE TESTE
	ADD R8,#1
	B TESTE
;;Fim do teste

;;Adiciona o número na memória
ADICIONAR
	CMP R8,#1
	BNE REPETIR1
	STRB R1,[R2],#1;;coloca o dado 
	B REPETIR1
FIM1

;;Funcao de ordenacao

	MOV R6,#19;;indice do loop 1
	
LOOP1
	MOV R7,#19;;indice do loop 2
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
	BLO LOOP3;;se r0 for maior que r1 repete o loop 3 sem trocar
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

	
TEXTO DCB 3,10,73,127,43,14,211,3,203,5,21,7,206,233,157,237,241,105,252,19,0;; O 0 indicca o fim da lista
	ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
