	include "neogeo.inc"
	include "macros.inc"
	include "sp1.inc"

	global manual_white_screen_test
	global STR_WHITE_SCREEN

	section text

manual_white_screen_test:
		; --- Setup colors ---
		; Set Palette 1, Color 1 to Full White ($7FFF)
		move.w	#$7fff, PALETTE_RAM_START + PALETTE_SIZE + 2
		; Set Backdrop to Full White
		move.w	#$7fff, PALETTE_BACKDROP

		bsr	draw_white_screen

	.loop_run_test:
		WATCHDOG
		bsr	p1p2_input_update
		bsr	wait_frame

		btst	#D_BUTTON, p1_input_edge
		beq	.loop_run_test

		; --- Cleanup / Restore State ---
		; Restore Backdrop to Black
		clr.w	PALETTE_BACKDROP

		; Restore Palette 1, Color 1 to Gray (Standard for disabled menu items)
		move.l	#$07770000, PALETTE_RAM_START + PALETTE_SIZE + 2

		; Clear screen (Space tile)
		SSA3	fix_clear
		rts

draw_white_screen:
		; Use fix_fill_ssa3 to fill screen with Tile $00 + Palette 1 ($1000)
		; This ensures active pixels are driving white, not just backdrop
		move.w	#$1000, d0
		SSA3	fix_fill
		rts

STR_WHITE_SCREEN:		STRING "WHITE SCREEN"
