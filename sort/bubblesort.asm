;==================
; BUBBLE SORT
;==================

;SORT_Bubble8Bit
;       sorts a list of unsigned bytes in place, not entirely useless for C64
;       as sprite multiplexors use 'almost' sorted lists and so bubble sort can
;       exit early when handling them
;       PARAM1 - low byte of address of first item in list
;       PARAM2 - high byte of address of first item in list
;       PARAM3 - length of list, number of items to sort
;       RETVAL1 - number of passes to sort

!zone SORT_Bubble8Bit
SORT_Bubble8Bit

        lda PARAM1
        sta ZEROPAGE_POINTER_1
        lda PARAM2
        sta ZEROPAGE_POINTER_1 + 1

        dec PARAM3      ; size of list
        ldx #$00        ; did a swap happen?
        ldy #$00        ; zeropage addressing offset
        sty RETVAL1     ; number of passes

.BubbleLoop
        lda (ZEROPAGE_POINTER_1),y
        iny 
        cmp (ZEROPAGE_POINTER_1),y
        ; carry is set if number in accumulator is larger than one encountered
        bcc .NoSwapNeeded
        beq .NoSwapNeeded

.SwapValues
        ; make the swap, this could probably be more efficient
        inx     ; register that a swap happened
        sta PARAM4
        lda (ZEROPAGE_POINTER_1),y
        dey
        sta (ZEROPAGE_POINTER_1),y
        iny
        lda PARAM4
        sta (ZEROPAGE_POINTER_1),y
        
.NoSwapNeeded
        cpy PARAM3      ; check if we've hit the end of the list
        bne .BubbleLoop

.CheckEndOfLoop
        ; this should be hit at the end of every pass
        inc RETVAL1
        cpx #$00        ; check if no exchanges were needed and exit early
        beq .BubbleDone

        ldy #$00        ; prepare for another pass
        ldx #$00
        jmp .BubbleLoop

.BubbleDone
        
        

        
