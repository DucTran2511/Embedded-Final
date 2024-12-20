
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _checksum=R4
	.DEF _checksum_msb=R5
	.DEF _x=R7
	.DEF _nhietdo=R6
	.DEF _doam=R9
	.DEF __lcd_x=R8
	.DEF __lcd_y=R11
	.DEF __lcd_maxx=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G104:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G104:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0
_0x26:
	.DB  0x30,0x30,0x30,0x30
_0x27:
	.DB  0x0,0x0,0x1,0x0,0x2,0x0,0x3,0x0
	.DB  0x4,0x0,0x5,0x0,0x6,0x0,0x7,0x0
	.DB  0x8
_0x0:
	.DB  0x54,0x45,0x4D,0x50,0x3A,0x0,0x48,0x55
	.DB  0x4D,0x49,0x3A,0x0,0x4D,0x41,0x58,0x20
	.DB  0x54,0x45,0x4D,0x50,0x3A,0x20,0x25,0x64
	.DB  0x5F,0x0,0x4D,0x41,0x58,0x20,0x54,0x45
	.DB  0x4D,0x50,0x3A,0x20,0x25,0x64,0x25,0x64
	.DB  0x0,0x4D,0x41,0x58,0x20,0x48,0x55,0x4D
	.DB  0x3A,0x20,0x25,0x64,0x5F,0x0,0x4D,0x41
	.DB  0x58,0x20,0x48,0x55,0x4D,0x3A,0x20,0x25
	.DB  0x64,0x25,0x64,0x0
_0x2060003:
	.DB  0x80,0xC0
_0x2120060:
	.DB  0x1
_0x2120000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x04
	.DW  _input_password
	.DW  _0x26*2

	.DW  0x11
	.DW  _keypad
	.DW  _0x27*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

	.DW  0x01
	.DW  __seed_G109
	.DW  _0x2120060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*
; * Ex1.c
; *
; * Created: 12/20/2024 12:59:56 PM
; * Author: ADMIN
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <glcd.h>
;#include <font5x7.h>
;#include <dht11.c>
;#include <io.h>
;#include <alcd.h>
;#include <delay.h>
;
;#define PIN_DHT PINB.7
;#define PORT_DHT PORTB.7
;#define DDR_DHT DDRB.7
;
;int checksum=0;
;
;char dht11(unsigned char *nhietdo, unsigned char *doam) {
; 0000 000C char dht11(unsigned char *nhietdo, unsigned char *doam) {

	.CSEG
_dht11:
; .FSTART _dht11
;    int i, j;
;    int buffer[5] = {0,0,0,0,0};
;    // buoc 1
;    DDR_DHT = 1;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,10
	LDI  R24,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x3*2)
	LDI  R31,HIGH(_0x3*2)
	CALL __INITLOCB
	CALL __SAVELOCR4
;	*nhietdo -> Y+16
;	*doam -> Y+14
;	i -> R16,R17
;	j -> R18,R19
;	buffer -> Y+4
	SBI  0x17,7
;    PORT_DHT = 1;
	SBI  0x18,7
;    delay_us(60);
	__DELAY_USB 160
;    // buoc 2
;    PORT_DHT = 0;
	CBI  0x18,7
;    delay_ms(25);
	LDI  R26,LOW(25)
	LDI  R27,0
	CALL _delay_ms
;    // buoc 3
;    DDR_DHT = 0;
	CBI  0x17,7
;    PORT_DHT = 1;
	SBI  0x18,7
;
;    // high
;    // check pin
;    delay_us(60);
	__DELAY_USB 160
;    if (PIN_DHT) return 0;  // high
	SBIS 0x16,7
	RJMP _0xE
	LDI  R30,LOW(0)
	RJMP _0x2140003
;    else while (!(PIN_DHT));
_0xE:
_0x10:
	SBIS 0x16,7
	RJMP _0x10
;    delay_us(60);
	__DELAY_USB 160
;    if (!PIN_DHT) return 0;
	SBIC 0x16,7
	RJMP _0x13
	LDI  R30,LOW(0)
	RJMP _0x2140003
;    else while ((PIN_DHT));
_0x13:
_0x15:
	SBIC 0x16,7
	RJMP _0x15
;
;
;    for (i = 0;i < 5;++ i) {
	__GETWRN 16,17,0
_0x19:
	__CPWRN 16,17,5
	BRGE _0x1A
;        for (j = 0;j < 8;++ j) {
	__GETWRN 18,19,0
_0x1C:
	__CPWRN 18,19,8
	BRGE _0x1D
;            while (!(PIN_DHT));
_0x1E:
	SBIS 0x16,7
	RJMP _0x1E
;            delay_us(50);
	__DELAY_USB 133
;            if (PIN_DHT) {
	SBIS 0x16,7
	RJMP _0x21
;                buffer[i] |= (1<<(7-j));
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,4
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R24,R30
	LD   R22,Z
	LDD  R23,Z+1
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	SUB  R30,R18
	SBC  R31,R19
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	OR   R30,R22
	OR   R31,R23
	MOVW R26,R24
	ST   X+,R30
	ST   X,R31
;                while ((PIN_DHT));
_0x22:
	SBIC 0x16,7
	RJMP _0x22
;            }
;        }
_0x21:
	__ADDWRN 18,19,1
	RJMP _0x1C
_0x1D:
;    }
	__ADDWRN 16,17,1
	RJMP _0x19
_0x1A:
;    checksum = buffer[0] + buffer[1] + buffer[2] + buffer[3];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R4,R30
;
;    if((checksum)!=buffer[4]) return 0;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x25
	LDI  R30,LOW(0)
	RJMP _0x2140003
;
;    *nhietdo = buffer[2];
_0x25:
	LDD  R30,Y+8
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ST   X,R30
;    *doam = buffer[0];
	LDD  R30,Y+4
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ST   X,R30
;    return 1;
	LDI  R30,LOW(1)
_0x2140003:
	CALL __LOADLOCR4
	ADIW R28,18
	RET
;}
; .FEND
;#include <stdio.h>
;
;char input_password[5] = {'0', '0', '0', '0'};

	.DSEG
;char x = 0;
;unsigned char nhietdo = 0, doam = 0;
;int keypad[3][3] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
;
;void hien_thi() {
; 0000 0014 void hien_thi() {

	.CSEG
_hien_thi:
; .FSTART _hien_thi
; 0000 0015     x = dht11(&nhietdo, &doam);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	LDI  R27,HIGH(9)
	RCALL _dht11
	MOV  R7,R30
; 0000 0016 
; 0000 0017     if (x == 1) {
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x28
; 0000 0018         lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0019         lcd_putsf("TEMP:");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 001A         lcd_putchar(nhietdo / 10 + 48);
	MOV  R26,R6
	CALL SUBOPT_0x0
; 0000 001B         lcd_putchar(nhietdo % 10 + 48);
	MOV  R26,R6
	CALL SUBOPT_0x1
; 0000 001C         lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 001D         lcd_putsf("HUMI:");
	__POINTW2FN _0x0,6
	CALL _lcd_putsf
; 0000 001E         lcd_putchar(doam / 10 + 48);
	MOV  R26,R9
	CALL SUBOPT_0x0
; 0000 001F         lcd_putchar(doam % 10 + 48);
	MOV  R26,R9
	CALL SUBOPT_0x1
; 0000 0020     }
; 0000 0021 }
_0x28:
	RET
; .FEND
;
;void BUTTON() {
; 0000 0023 void BUTTON() {
_BUTTON:
; .FSTART _BUTTON
; 0000 0024     int i, j, index = 0;
; 0000 0025     char buffer[16];
; 0000 0026     while (index < 4) { // Nhap du 4 ki tu
	SBIW R28,16
	CALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	index -> R20,R21
;	buffer -> Y+6
	__GETWRN 20,21,0
_0x29:
	__CPWRN 20,21,4
	BRLT PC+2
	RJMP _0x2B
; 0000 0027         for (j = 0; j < 3; j++) {
	__GETWRN 18,19,0
_0x2D:
	__CPWRN 18,19,3
	BRLT PC+2
	RJMP _0x2E
; 0000 0028             if (j == 0) PORTF = 0b11111101;
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x2F
	LDI  R30,LOW(253)
	STS  98,R30
; 0000 0029             if (j == 1) PORTF = 0b11110111;
_0x2F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x30
	LDI  R30,LOW(247)
	STS  98,R30
; 0000 002A             if (j == 2) PORTF = 0b11011111;
_0x30:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x31
	LDI  R30,LOW(223)
	STS  98,R30
; 0000 002B             for (i = 0; i < 3; i++) {
_0x31:
	__GETWRN 16,17,0
_0x33:
	__CPWRN 16,17,3
	BRLT PC+2
	RJMP _0x34
; 0000 002C                 if ((i == 0 && PINF.2 == 0) ||
; 0000 002D                     (i == 1 && PINF.4 == 0) ||
; 0000 002E                     (i == 2 && PINF.0 == 0)) {
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x36
	SBIS 0x0,2
	RJMP _0x38
_0x36:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x39
	SBIS 0x0,4
	RJMP _0x38
_0x39:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x3B
	SBIS 0x0,0
	RJMP _0x38
_0x3B:
	RJMP _0x35
_0x38:
; 0000 002F                     input_password[index] = keypad[i][j] + '0'; // Luu ki tu nhap vao
	MOVW R30,R20
	SUBI R30,LOW(-_input_password)
	SBCI R31,HIGH(-_input_password)
	MOVW R22,R30
	__MULBNWRU 16,17,6
	SUBI R30,LOW(-_keypad)
	SBCI R31,HIGH(-_keypad)
	MOVW R26,R30
	MOVW R30,R18
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
; 0000 0030                     if(index == 0){
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x3E
; 0000 0031                         sprintf(buffer, "MAX TEMP: %d_", input_password[index]);
	CALL SUBOPT_0x2
	__POINTW1FN _0x0,12
	CALL SUBOPT_0x3
; 0000 0032                     }else if(index == 1){
	RJMP _0x3F
_0x3E:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x40
; 0000 0033                         sprintf(buffer, "MAX TEMP: %d%d", input_password[index-1], input_password[index]);
	CALL SUBOPT_0x2
	__POINTW1FN _0x0,26
	RJMP _0x57
; 0000 0034                     }else if(index == 2){
_0x40:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x42
; 0000 0035                         sprintf(buffer, "MAX HUM: %d_", input_password[index]);
	CALL SUBOPT_0x2
	__POINTW1FN _0x0,41
	CALL SUBOPT_0x3
; 0000 0036                     }else{
	RJMP _0x43
_0x42:
; 0000 0037                         sprintf(buffer, "MAX HUM: %d%d", input_password[index-1], input_password[index]);
	CALL SUBOPT_0x2
	__POINTW1FN _0x0,54
_0x57:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	SBIW R30,1
	SUBI R30,LOW(-_input_password)
	SBCI R31,HIGH(-_input_password)
	LD   R30,Z
	CALL SUBOPT_0x4
	LDI  R26,LOW(_input_password)
	LDI  R27,HIGH(_input_password)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 0038                     }
_0x43:
_0x3F:
; 0000 0039                     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 003A                     index++;
	__ADDWRN 20,21,1
; 0000 003B                     break;
	RJMP _0x34
; 0000 003C                 }
; 0000 003D             }
_0x35:
	__ADDWRN 16,17,1
	RJMP _0x33
_0x34:
; 0000 003E         }
	__ADDWRN 18,19,1
	RJMP _0x2D
_0x2E:
; 0000 003F     }
	RJMP _0x29
_0x2B:
; 0000 0040     input_password[4] = '\0'; // Ket thuc chuoi
	LDI  R30,LOW(0)
	__PUTB1MN _input_password,4
; 0000 0041 }
	CALL __LOADLOCR6
	ADIW R28,22
	RET
; .FEND
;
;void display_max_ht(){
; 0000 0043 void display_max_ht(){
_display_max_ht:
; .FSTART _display_max_ht
; 0000 0044     char buffer[16];
; 0000 0045     lcd_clear();
	SBIW R28,16
;	buffer -> Y+0
	CALL _lcd_clear
; 0000 0046     lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL SUBOPT_0x6
; 0000 0047     sprintf(buffer, "MAX TEMP: %d%d", input_password[0], input_password[1]);
	__POINTW1FN _0x0,26
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_input_password
	CALL SUBOPT_0x4
	__GETB1MN _input_password,1
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 0048     lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
; 0000 0049     sprintf(buffer, "MAX HUM: %d%d", input_password[3], input_password[4]);
	__POINTW1FN _0x0,54
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _input_password,3
	CALL SUBOPT_0x4
	__GETB1MN _input_password,4
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 004A 
; 0000 004B }
	ADIW R28,16
	RET
; .FEND
;
;void main(){
; 0000 004D void main(){
_main:
; .FSTART _main
; 0000 004E bool state_1 = true;
; 0000 004F bool state_2 = true;
; 0000 0050 DDRB = 0x00;
;	state_1 -> R17
;	state_2 -> R16
	LDI  R17,1
	LDI  R16,1
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0051 PORTB = 0x04;
	LDI  R30,LOW(4)
	OUT  0x18,R30
; 0000 0052 while(1){
_0x44:
; 0000 0053     // Button 1
; 0000 0054     if(PINB.2 == 0){
	SBIC 0x16,2
	RJMP _0x47
; 0000 0055             delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 0056             if(PINB.2 == 0){
	SBIC 0x16,2
	RJMP _0x48
; 0000 0057                 state_1 = !state_1;
	MOV  R30,R17
	CALL __LNEGB1
	MOV  R17,R30
; 0000 0058             }
; 0000 0059     }
_0x48:
; 0000 005A 
; 0000 005B     // Button 2
; 0000 005C     if(PINB.3 == 0){
_0x47:
	SBIC 0x16,3
	RJMP _0x49
; 0000 005D             delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 005E             if(PINB.3 == 0){
	SBIC 0x16,3
	RJMP _0x4A
; 0000 005F                 state_2 = !state_2;
	MOV  R30,R16
	CALL __LNEGB1
	MOV  R16,R30
; 0000 0060             }
; 0000 0061     }
_0x4A:
; 0000 0062 
; 0000 0063     if(state_1 == true && state_2 == true){
_0x49:
	CPI  R17,1
	BRNE _0x4C
	CPI  R16,1
	BREQ _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 0064         hien_thi();
	RCALL _hien_thi
; 0000 0065     }else if (state_1 == false && state_2 == true){ // If button 1 is pressed
	RJMP _0x4E
_0x4B:
	CPI  R17,0
	BRNE _0x50
	CPI  R16,1
	BREQ _0x51
_0x50:
	RJMP _0x4F
_0x51:
; 0000 0066         BUTTON();
	RCALL _BUTTON
; 0000 0067     }else if (state_1 == true && state_2 == false){ // If button 2 is pressed
	RJMP _0x52
_0x4F:
	CPI  R17,1
	BRNE _0x54
	CPI  R16,0
	BREQ _0x55
_0x54:
	RJMP _0x53
_0x55:
; 0000 0068         display_max_ht();
	RCALL _display_max_ht
; 0000 0069     }
; 0000 006A 
; 0000 006B }
_0x53:
_0x52:
_0x4E:
	RJMP _0x44
; 0000 006C }
_0x56:
	RJMP _0x56
; .FEND
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G103:
; .FSTART __lcd_write_nibble_G103
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2060004
	SBI  0x1B,3
	RJMP _0x2060005
_0x2060004:
	CBI  0x1B,3
_0x2060005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2060006
	SBI  0x1B,4
	RJMP _0x2060007
_0x2060006:
	CBI  0x1B,4
_0x2060007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2060008
	SBI  0x1B,5
	RJMP _0x2060009
_0x2060008:
	CBI  0x1B,5
_0x2060009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x206000A
	SBI  0x1B,6
	RJMP _0x206000B
_0x206000A:
	CBI  0x1B,6
_0x206000B:
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2140002
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G103
	__DELAY_USB 133
	RJMP _0x2140002
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R8,Y+1
	LDD  R11,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x7
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x7
	LDI  R30,LOW(0)
	MOV  R11,R30
	MOV  R8,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2060011
	CP   R8,R10
	BRLO _0x2060010
_0x2060011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R11
	MOV  R26,R11
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2140002
_0x2060010:
	INC  R8
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
_0x2140002:
	ADIW R28,1
	RET
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2060017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2060017
_0x2060019:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G104:
; .FSTART _put_buff_G104
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2080010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2080012
	__CPWRN 16,17,2
	BRLO _0x2080013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2080012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2080013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2080014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2080014:
	RJMP _0x2080015
_0x2080010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2080015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G104:
; .FSTART __print_G104
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2080016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2080018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x208001C
	CPI  R18,37
	BRNE _0x208001D
	LDI  R17,LOW(1)
	RJMP _0x208001E
_0x208001D:
	CALL SUBOPT_0x8
_0x208001E:
	RJMP _0x208001B
_0x208001C:
	CPI  R30,LOW(0x1)
	BRNE _0x208001F
	CPI  R18,37
	BRNE _0x2080020
	CALL SUBOPT_0x8
	RJMP _0x20800CC
_0x2080020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2080021
	LDI  R16,LOW(1)
	RJMP _0x208001B
_0x2080021:
	CPI  R18,43
	BRNE _0x2080022
	LDI  R20,LOW(43)
	RJMP _0x208001B
_0x2080022:
	CPI  R18,32
	BRNE _0x2080023
	LDI  R20,LOW(32)
	RJMP _0x208001B
_0x2080023:
	RJMP _0x2080024
_0x208001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2080025
_0x2080024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2080026
	ORI  R16,LOW(128)
	RJMP _0x208001B
_0x2080026:
	RJMP _0x2080027
_0x2080025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x208001B
_0x2080027:
	CPI  R18,48
	BRLO _0x208002A
	CPI  R18,58
	BRLO _0x208002B
_0x208002A:
	RJMP _0x2080029
_0x208002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x208001B
_0x2080029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x208002F
	CALL SUBOPT_0x9
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xA
	RJMP _0x2080030
_0x208002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2080032
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2080033
_0x2080032:
	CPI  R30,LOW(0x70)
	BRNE _0x2080035
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2080033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2080036
_0x2080035:
	CPI  R30,LOW(0x64)
	BREQ _0x2080039
	CPI  R30,LOW(0x69)
	BRNE _0x208003A
_0x2080039:
	ORI  R16,LOW(4)
	RJMP _0x208003B
_0x208003A:
	CPI  R30,LOW(0x75)
	BRNE _0x208003C
_0x208003B:
	LDI  R30,LOW(_tbl10_G104*2)
	LDI  R31,HIGH(_tbl10_G104*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x208003D
_0x208003C:
	CPI  R30,LOW(0x58)
	BRNE _0x208003F
	ORI  R16,LOW(8)
	RJMP _0x2080040
_0x208003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2080071
_0x2080040:
	LDI  R30,LOW(_tbl16_G104*2)
	LDI  R31,HIGH(_tbl16_G104*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x208003D:
	SBRS R16,2
	RJMP _0x2080042
	CALL SUBOPT_0x9
	CALL SUBOPT_0xC
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2080043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2080043:
	CPI  R20,0
	BREQ _0x2080044
	SUBI R17,-LOW(1)
	RJMP _0x2080045
_0x2080044:
	ANDI R16,LOW(251)
_0x2080045:
	RJMP _0x2080046
_0x2080042:
	CALL SUBOPT_0x9
	CALL SUBOPT_0xC
_0x2080046:
_0x2080036:
	SBRC R16,0
	RJMP _0x2080047
_0x2080048:
	CP   R17,R21
	BRSH _0x208004A
	SBRS R16,7
	RJMP _0x208004B
	SBRS R16,2
	RJMP _0x208004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x208004D
_0x208004C:
	LDI  R18,LOW(48)
_0x208004D:
	RJMP _0x208004E
_0x208004B:
	LDI  R18,LOW(32)
_0x208004E:
	CALL SUBOPT_0x8
	SUBI R21,LOW(1)
	RJMP _0x2080048
_0x208004A:
_0x2080047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x208004F
_0x2080050:
	CPI  R19,0
	BREQ _0x2080052
	SBRS R16,3
	RJMP _0x2080053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2080054
_0x2080053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2080054:
	CALL SUBOPT_0x8
	CPI  R21,0
	BREQ _0x2080055
	SUBI R21,LOW(1)
_0x2080055:
	SUBI R19,LOW(1)
	RJMP _0x2080050
_0x2080052:
	RJMP _0x2080056
_0x208004F:
_0x2080058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x208005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x208005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x208005A
_0x208005C:
	CPI  R18,58
	BRLO _0x208005D
	SBRS R16,3
	RJMP _0x208005E
	SUBI R18,-LOW(7)
	RJMP _0x208005F
_0x208005E:
	SUBI R18,-LOW(39)
_0x208005F:
_0x208005D:
	SBRC R16,4
	RJMP _0x2080061
	CPI  R18,49
	BRSH _0x2080063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2080062
_0x2080063:
	RJMP _0x20800CD
_0x2080062:
	CP   R21,R19
	BRLO _0x2080067
	SBRS R16,0
	RJMP _0x2080068
_0x2080067:
	RJMP _0x2080066
_0x2080068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2080069
	LDI  R18,LOW(48)
_0x20800CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x208006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xA
	CPI  R21,0
	BREQ _0x208006B
	SUBI R21,LOW(1)
_0x208006B:
_0x208006A:
_0x2080069:
_0x2080061:
	CALL SUBOPT_0x8
	CPI  R21,0
	BREQ _0x208006C
	SUBI R21,LOW(1)
_0x208006C:
_0x2080066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2080059
	RJMP _0x2080058
_0x2080059:
_0x2080056:
	SBRS R16,0
	RJMP _0x208006D
_0x208006E:
	CPI  R21,0
	BREQ _0x2080070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xA
	RJMP _0x208006E
_0x2080070:
_0x208006D:
_0x2080071:
_0x2080030:
_0x20800CC:
	LDI  R17,LOW(0)
_0x208001B:
	RJMP _0x2080016
_0x2080018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0xD
	SBIW R30,0
	BRNE _0x2080072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2140001
_0x2080072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0xD
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G104)
	LDI  R31,HIGH(_put_buff_G104)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G104
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2140001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_glcd_state:
	.BYTE 0x1D
_input_password:
	.BYTE 0x5
_keypad:
	.BYTE 0x12
_gfx_addr_G100:
	.BYTE 0x2
_gfx_buffer_G100:
	.BYTE 0x1F8
__base_y_G103:
	.BYTE 0x4
__seed_G109:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_input_password)
	LDI  R27,HIGH(_input_password)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL _lcd_gotoxy
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
