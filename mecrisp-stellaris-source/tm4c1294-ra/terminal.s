@
@    Mecrisp-Stellaris - A native code Forth implementation for ARM-Cortex M microcontrollers
@    Copyright (C) 2013  Matthias Koch
@
@    This program is free software: you can redistribute it and/or modify
@    it under the terms of the GNU General Public License as published by
@    the Free Software Foundation, either version 3 of the License, or
@    (at your option) any later version.
@
@    This program is distributed in the hope that it will be useful,
@    but WITHOUT ANY WARRANTY; without even the implied warranty of
@    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
@    GNU General Public License for more details.
@
@    You should have received a copy of the GNU General Public License
@    along with this program.  If not, see <http://www.gnu.org/licenses/>.
@

@ Terminalroutinen
@ Terminal code and initialisations.
@ Porting: Rewrite this !

.equ RCGCPIO,    0x400FE608
.equ RCGCUART,   0x400FE618

.equ GPIO_PORTA_AHB_AFSEL_R,  0x40058420
.equ GPIO_PORTA_AHB_DEN_R,    0x4005851C
.equ GPIO_PORTA_AHB_PCTL_R,   0x4005852C

.equ Terminal_UART_Base, 0x4000C000 @ UART 0
.include "../common/ti-terminal.s"

@ -----------------------------------------------------------------------------
uart_init: @ ( -- )
@ -----------------------------------------------------------------------------

  @ Allgemeine Systemeinstellungen

  movw r1, #0x7FFF    @ Alle GPIO-Ports aktivieren
  ldr  r0, =RCGCPIO
  str  r1, [r0]

  movs r1, #1         @ UART0 aktivieren
  ldr  r0, =RCGCUART
  str  r1, [r0]

  movs r1, #0x11      @ In diesem Chip ist die serielle Schnittstelle nicht standardmäßig als Sonderfunktion aktiviert
  ldr r0, =GPIO_PORTA_AHB_PCTL_R
  str r1, [r0]

  movs r1, #3         @ PA0 und PA1 auf UART-Sonderfunktion schalten
  ldr  r0, =GPIO_PORTA_AHB_AFSEL_R
  str  r1, [r0]

  @ movs r1, #3       @ PA0 und PA1 als digitale Leitungen aktivieren
  ldr  r0, =GPIO_PORTA_AHB_DEN_R
  str  r1, [r0]

  Set_Terminal_UART_Baudrate

  bx lr

  .ltorg @ Hier werden viele spezielle Hardwarestellenkonstanten gebraucht, schreibe sie gleich !
