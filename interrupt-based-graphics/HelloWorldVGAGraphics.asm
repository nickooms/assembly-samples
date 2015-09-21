use16

floppy_drive_number                           equ   0x00

floppy_drive_reset_disk_operation             equ   0x00
floppy_drive_reset_disk_interrupt             equ   0x13

floppy_drive_read_sector_operation            equ   0x02
floppy_drive_read_sector_interrupt            equ   0x13

floppy_drive_boot_sector_address              equ   0x7C00
floppy_drive_boot_sector_sector_count         equ   0x01
floppy_drive_boot_sector_cylinder_number      equ   0x00
floppy_drive_boot_sector_head_number          equ   0x00
floppy_drive_boot_sector_start_sector_number  equ   0x02
floppy_drive_boot_sector_last_2_bytes         equ   0xAA55
floppy_drive_boot_sector_next_sector          equ   0x7E00

vga_interrupt                                 equ   0x10
vga_set_mode_operation                        equ   0x00
vga_mode_320_x_200_256_colors                 equ   0x13
vga_draw_pixel_operation                      equ   0x0C

rect_left                                     equ   80
rect_top                                      equ   50
rect_right                                    equ   240
rect_bottom                                   equ   150
rect_color                                    equ   0x0F

org           floppy_drive_boot_sector_address

boot_stage_one:
  mov   ah,   floppy_drive_reset_disk_operation
  mov   dl,   floppy_drive_number
  int         floppy_drive_reset_disk_interrupt

  mov   ah,   floppy_drive_read_sector_operation
  mov   al,   floppy_drive_boot_sector_sector_count
  mov   dl,   floppy_drive_number
  mov   ch,   floppy_drive_boot_sector_cylinder_number
  mov   dh,   floppy_drive_boot_sector_head_number
  mov   cl,   floppy_drive_boot_sector_start_sector_number
  mov   bx,   main
  int         floppy_drive_read_sector_interrupt

  jmp         main

  times       ((0x0200 - 2) - ($ - $$))       db    0h
  dw          floppy_drive_boot_sector_last_2_bytes

org           floppy_drive_boot_sector_next_sector

main:
  mov   ah,   vga_set_mode_operation
  mov   al,   vga_mode_320_x_200_256_colors
  int         vga_interrupt
  mov   cx,   rect_left
  mov   dx,   rect_top
  jmp         draw_pixel
  draw_pixel_end:
ret

draw_pixel:
  mov   ah,   vga_draw_pixel_operation
  mov   al,   rect_color
  int         vga_interrupt
  cmp   cx,   rect_right
  jne         next_pixel_x
  cmp   dx,   rect_bottom
  jne         next_pixel_y
jmp           draw_pixel_end

next_pixel_x:
  inc   cx
jmp           draw_pixel

next_pixel_y:
  inc   dx
  mov   cx,   rect_left
jmp           draw_pixel

  times       ((0x0200) - ($ - $$))             db      0h
