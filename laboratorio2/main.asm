//*****************************************************************************
//Universidad del Valle de Guatemala
//IE2023 Programacionde Microcontroladores
//Author : Nicole Navas
//Proyecto: Prelab2: Contador 4 bits
//IDescripcion: Codigo de contador 4 bits
//Hardware: ATMega328P
//Created: 2/4/2024 4:07:39 PM
// Actualizado: 2/5/2024
//*****************************************************************************
// Encabezado
//*****************************************************************************
.INCLUDE "M328PDEF.inc"
.CSEG //Inicio del código
.ORG 0x00 //Vector RESET, dirección incial
//*****************************************************************************
// Stack Pointer
//*****************************************************************************
	LDI R16, LOW(RAMEND)
	OUT SPL, R16
	LDI R17, HIGH(RAMEND)
	OUT SPH, R17
//*****************************************************************************
// Tabla del display
//*****************************************************************************
	TABLA7SEG: .DB 0b0011_1111, 0b0000_0110, 0b0101_1011, 0b0100_1111, 0b0110_0110, 0b0110_1101, 0b0111_1101, 0b0000_0111, 0b0111_1111, 0b0110_1111, 0b0111_0111, 0b0111_1100, 0b0011_1001, 0b0101_1110, 0b0111_1001, 0b0111_0001


//*****************************************************************************
// Configuracion
//*****************************************************************************
Setup:
	
    LDI R16, 0b1000_0000
    STS CLKPR, R16

	LDI R16, 0b0000_0100 
	STS CLKPR, R16

	LDI R16, 0b0000_0000 //Seteo de los botones puestos en el PORTC
	OUT DDRC, R16 
	LDI R16, 0b0000_1111 //Definiendo los botones como pull-ups
	OUT PORTC, R16


	LDI R16, 0b1111_1111
	OUT DDRD, R16

	SEI

	LDI R17, 0b0000_0001
	LDI ZH, HIGH (TABLA7SEG << 1)
	LDI ZL, LOW (TABLA7SEG << 1)
	LPM R18, Z
	OUT PORTD, R18

	LDI R17, 0b1111_1111 
	OUT DDRD, R17        
	LDI R17, 0b0000_0000
	OUT PORTD, R19
	LDI R19, 0x00
	STS UCSR0B, R19
	OUT PORTD, R19

	LDI R20, 0b000_0000
	LDI R17, 0b0000_0001
	
loop:
	IN R19, PINC

	SBRS R19, PC0
	RJMP delayi

	
	SBRS R19, PC1
	RJMP delayd

	RJMP loop

	
//*****************************************************************************
// Sub-rutinas
//*****************************************************************************
delayi:
	LDI R16, 100

	delay1:
		DEC R16
		BRNE delay1
		
	IN R19, PINC
	SBRS R19, PC0
	RJMP delayi

	CPI R20, 15
	BRNE incrementar
	RJMP loop

delayd:
	LDI R16, 100

	delay2:
		DEC R16
		BRNE delay2

	IN R19, PINC
	SBRS R19, PC1
	RJMP delayd

	CPI R20, 0
	BRNE decrementar
	RJMP loop


incrementar:
	INC R20

	ADD ZL, R17
	RJMP display

decrementar:
	DEC R20
	SUB ZL, R17
	RJMP display

	

display: 
	LPM R18, Z
	OUT PORTD, R18
	RJMP loop