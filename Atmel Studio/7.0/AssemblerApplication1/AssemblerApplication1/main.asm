;
; AssemblerApplication1.asm
;
; Created: 08.06.2017 09:37:51
; Author : User
;


; Replace with your application code

ldi R16,254		; R16 = 254
ldi R17,7		; R17 = 7	
mov R20,R17		; R20 = 7
mov R19,R16		; R19 = 254
add R19,R20		; R19 = 7 + 254 = 5, C = 1
adc R20,R17		; R20 = 7 + 7 + C = 15
eor R17, R17	; R17 = 0
eor R17, R16	; R17 = 254
subi R17,255		; R17 = 254 - 255 = 255
sbci R16,10		; R16 = 254 - 10 - 1 = 243 
rjmp pushy

pushy : 
push R20		; RAM(SP0) = 15
push R19		; RAM(SP1) = 5
pop R16			; R16 = RAM(SP1) = 5
pop R17			; R17 = RAM(SP0) = 15
