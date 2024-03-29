; tests for the c64 subroutines

!source "common/common.asm"      ; sort of a 'header' file
; set up the values to multiply and the results
EXPECTED_LO = $02a7     ; some unused memory
EXPECTED_HI = $02a8
CUR_TEST    = $0400     ; start of screen memory
PET_ZERO    = $30       ; '0' char in petscii

        * = $0801

        ; Autostart - SYS2064 in BASIC
        !byte $0c, $08, $0a, $00, $9e, $20, $32, $30, $36, $34, $00, $00, $00, $00, $00

        lda #PET_ZERO
        sta CUR_TEST
        inc CUR_TEST

!zone TEST_Multiply8Bit
        lda #$05
        sta PARAM1
        lda #$08
        sta PARAM2

        ; prepare the expected values
        lda #$00
        sta EXPECTED_HI
        lda #$28
        sta EXPECTED_LO

        jsr MATHS_Multiply8Bit

        lda RETVAL1
        cmp EXPECTED_LO
        bne .ErrorFound
        lda RETVAL2
        cmp EXPECTED_HI
        bne .ErrorFound

        jmp .NoError

.ErrorFound
        ; return to BASIC, top left corner should give index of failing test
        lda #BLACK
        sta $d020       ; border colour
        jmp .End

.NoError
        lda #GREEN
        sta $d020
        jmp TEST_BubbleSort
        
.End
        rts

!zone TEST_BubbleSort
TEST_BubbleSort
        inc CUR_TEST

.BubbleSetup
        ; unsorted list should be at $8000 (see below)
        lda #< UNSORTED_LIST_1
        sta PARAM1  
        lda #> UNSORTED_LIST_1
        sta PARAM2

        lda #$08
        sta PARAM3

        jsr SORT_Bubble8Bit

        ; best to use a monitor to check this...
        lda RETVAL1
        cmp #$05
        bne .ErrorFound

        ldx #$00
.CheckLoop
        lda UNSORTED_LIST_1,x
        cmp SORTED_LIST_1,x
        bne .ErrorFound
        inx
        cpx #$08
        bne .CheckLoop

        ; add number of passes to '0' char and show in top left corner (row 2)
        clc
        adc PET_ZERO
        sta CUR_TEST + 40       ; show number of passes on 2nd row
        jmp .NoError

.ErrorFound
        lda #BLACK
        sta $d020
        jmp .End

.NoError
        lda #GREEN
        sta $d020

.End
        rts
        
        * = $2000
        !source "maths/multiply8bit.asm"
        * = $2400
        !source "sort/bubblesort.asm"

!zone TEST_SortData
        * = $8000
UNSORTED_LIST_1
        !byte $04, $53, $ff, $01, $69, $02, $80, $53
SORTED_LIST_1
        !byte $01, $02, $04, $53, $53, $69, $80, $ff
