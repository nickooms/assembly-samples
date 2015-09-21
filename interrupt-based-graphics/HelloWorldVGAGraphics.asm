use16

FLOPPY_DRIVE_NUMBER                             equ 0

FLOPPY_DRIVE_RESET_DISK_OPERATION               equ 0x00
FLOPPY_DRIVE_RESET_DISK_INTERRUPT               equ 0x13

FLOPPY_DRIVE_READ_SECTOR_OPERATION              equ 0x02
FLOPPY_DRIVE_READ_SECTOR_INTERRUPT              equ 0x13

FLOPPY_DRIVE_BOOT_SECTOR_ADDRESS                equ 0x7C00
FLOPPY_DRIVE_BOOT_SECTOR_SECTOR_COUNT           equ 1
FLOPPY_DRIVE_BOOT_SECTOR_CYLINDER_NUMBER        equ 0
FLOPPY_DRIVE_BOOT_SECTOR_HEAD_NUMBER            equ 0
FLOPPY_DRIVE_BOOT_SECTOR_START_SECTOR_NUMBER    equ 2

DRAW_PIXEL_OPERATION                            equ 0x13
DRAW_PIXEL_INTERRUPT                            equ 0x10

org FLOPPY_DRIVE_BOOT_SECTOR_ADDRESS

bootStageOne:
    mov ah, FLOPPY_DRIVE_RESET_DISK_OPERATION
    mov dl, FLOPPY_DRIVE_NUMBER
    int     FLOPPY_DRIVE_RESET_DISK_INTERRUPT

    mov ah, FLOPPY_DRIVE_READ_SECTOR_OPERATION
    mov al, FLOPPY_DRIVE_BOOT_SECTOR_SECTOR_COUNT
    mov dl, FLOPPY_DRIVE_NUMBER
    mov ch, FLOPPY_DRIVE_BOOT_SECTOR_CYLINDER_NUMBER
    mov dh, FLOPPY_DRIVE_BOOT_SECTOR_HEAD_NUMBER
    mov cl, FLOPPY_DRIVE_BOOT_SECTOR_START_SECTOR_NUMBER
    mov bx, main
    int     FLOPPY_DRIVE_READ_SECTOR_INTERRUPT

    jmp     main

padOutSector1WithZeroes: ; pad out all but last 2 bytes of the sector with zeroes
times ((0x200 - 2) - ($ - $$)) db 0x00
dw 0xAA55       ; these must be last 2 bytes in the boot sector

org 0x7E00          ; next sector

main:
    mov ax, DRAW_PIXEL_OPERATION
    int     DRAW_PIXEL_INTERRUPT
    mov cx, 80
    mov dx, 50
    jmp     drawPixel
    drawPixelEnd:
ret

drawPixel:
    mov ax, 0x0C0F
    int     0x10
    cmp cx, 240
    jne     nextPixelX
    cmp dx, 150
    jne     nextPixelY
jmp         drawPixelEnd

nextPixelX:
    inc cx
jmp         drawPixel

nextPixelY:
    inc dx
    mov cx, 80
jmp         drawPixel

padOutSector2WithZeroes:
times ((0x200) - ($ - $$)) db 0x00