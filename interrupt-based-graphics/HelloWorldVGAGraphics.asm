USE16
ORG 0x7C00          ; boot sector
BootStageOne
    MOV AH, 0x00    ; reset disk
    MOV DL, 0       ; drive number
    INT 0x13        ; load sector
    MOV AX, 0x0201  ; read 1 sector into memory
    MOV DL, 0       ; drive number
    MOV CH, 0       ; cylinder number
    MOV DH, 0       ; head number
    MOV CL, 2       ; starting sector number
    MOV BX, Main    ; memory location to load to 
    INT 0x13
    JMP Main

PadOutSector1WithZeroes ; pad out all but last 2 bytes of the sector with zeroes
    TIMES ((0x200 - 2) - ($ - $$)) DB 0x00
    DW 0xAA55       ; these must be last 2 bytes in the boot sector

ORG 0x7E00          ; next sector

Main
    MOV AX, 0x0013
    INT 0x10
    MOV CX, 80
    MOV DX, 50
    JMP DrawPixel
    DrawPixelEnd
RET

DrawPixel
    MOV AX, 0x0C0F
    INT 0x10
    CMP CX, 240
        JNE NextPixelX
    CMP DX, 150
        JNE NextPixelY
JMP DrawPixelEnd

NextPixelX
    ADD CX, 1
JMP DrawPixel

NextPixelY
    ADD DX, 1
    MOV CX, 80
JMP DrawPixel

PadOutSector2WithZeroes
    TIMES ((0x200) - ($ - $$)) DB 0x00