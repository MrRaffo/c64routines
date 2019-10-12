; output file name and target machine should be defined in a Makefile
; formatted for the ACME assembler

;========================
; MATHS FUNCTIONS
;========================

; MATHS_Multiply8Bit
;       multiplies 2 8 bit unsigned values together, returns 16 bit result
;       PARAM1 - first value to be multiplied
;       PARAM2 - second value to be multiplied
;       RETVAL1 - result low byte
;       RETVAL2 - result high byte

!zone MATHS_Multiply8Bit
MATHS_Multiply8Bit

        ; set answer to zero
        lda #$00
        sta RETVAL1
        sta RETVAL2

        ; find the lesser of the two operands
        ; if either of them are zero, return
        ldy PARAM2
        beq .MultiplyDone
        ldx PARAM1
        beq .MultiplyDone

        ; PARAM1 dictates how many times the loop runs, so if it is greater
        ; than PARAM2, switch them
        cpx PARAM2
        bcc .MultiplyLoopSetup       ; PARAM1 is less, so go to loop

        ; otherwise, switch parameters
        sty PARAM1
        stx PARAM2

.MultiplyLoopSetup
        ldx PARAM1      ; this is used as a loop counter
        ldy #$00        ; stores the high byte of the result
        clc
; Add PARAM2 to itself PARAM1 times
.MultiplyLoop
        adc PARAM2
        bcc .NoOverFlow

        iny             ; result low byte has overflown, so inc high byte
        clc

.NoOverFlow
        dex
        bne .MultiplyLoop       ; check if loop has run enough times

        ; loop is done, so store results
        sta RETVAL1     ; result low byte
        sty RETVAL2     ; result high byte

.MultiplyDone

        rts
