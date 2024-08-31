/**
MBR Concert Invitation
Code: Elder0010
Gfx: Elder0010
*/
.import source "variables.asm"

.pc = basic_upstart "[basic upstart]"
.byte $0e,$04,$0a,$00,$9e,$20,$28,$31,$30,$34,$30,$29,$00,$00,$00
start:
   //     jmp main_code
.pc = * "[main routine]"
        sei
        jsr clear_screen

frame:
//wait for vertical retrace start
!:
        lda VIA_PORT_B
        and #$20 
        bne !-

screen_fn:
        jsr write_page

headline_fn:
        bit write_headline

subtitle_fn:
        bit write_subtitle

scrolltext_fn:
        jsr scroller_delay

!:
        lda VIA_PORT_B
        and #$20 
        beq !-   

        jmp frame
       
clear_screen:
        lda #$20
        ldx #$0 
!: 
        sta screen,x 
        sta screen+$100,x
        sta screen+$200,x 
        sta screen+$300,x 
        dex 
        bne !-
        rts

write_headline:
        ldx #0 
        lda headline_text,x 
        sta HEADLINE_ADDR,x 
        inc write_headline+1
        lda write_headline+1
        cmp #$28
        bne !+
        lda #$2c //bit 
        sta headline_fn
        
        lda #$20 //jsr 
        sta subtitle_fn   
!:
        rts 

headline_pt:
.byte 0 

write_subtitle:
        ldx #0    
sbt_ad:
        lda subtitle_text,x 
        sta SUBTITLE_ADDR,x 
        inc write_subtitle+1
        lda write_subtitle+1
        cmp #$28
        bne skp0
         //handle delay
        dec write_subtitle+1
        inc dl0+1    
dl0:
        lda #0 
        cmp #SUBTITLE_DELAY
        beq !+
        rts 
!:
        lda #0 
        sta write_subtitle+1
        sta dl0+1

        inc subtitle_rows+1
subtitle_rows:
        lda #0 
        cmp #3 //number of subtitlerows
        bne nextln
        lda #<subtitle_text
        sta sbt_ad+1
        lda #>subtitle_text
        sta sbt_ad+2
        lda #0 
        sta subtitle_rows+1
        rts 
nextln:
        clc 
        lda sbt_ad+1
        adc #$28 
        sta sbt_ad+1
        bcc !+
        inc sbt_ad+2
!:
skp0:
        rts 

scroller_delay:
        lda #0
        cmp #SCROLLER_WAIT_TIME
        bne !+
        lda #<scroller 
        sta scrolltext_fn+1
        lda #>scroller 
        sta scrolltext_fn+2
!:
        inc scroller_delay+1
        rts 

scroller:
        ldx #$27
!:
scrollsrc:
        lda scrolltext,x
        bne nextch
//wrap around..
        lda #<scrolltext 
        sta scrollsrc+1
        lda #>scrolltext 
        sta scrollsrc+2
        lda scrolltext
 nextch:
        sta SCROLLTEXT_POS,x 
        dex 
        bpl !-

        inc scrolltext_tk+1
scrolltext_tk:
        lda #0 
        cmp #SCROLLTEXT_DELAY
        bne nomovescroller
        clc 
        lda scrollsrc+1
        adc #1
        sta scrollsrc+1
        bcc !+
        inc scrollsrc+2
!:
        lda #0 
        sta scrolltext_tk+1
nomovescroller:
        rts 

write_page:
        inc ftk+1
ftk:
        lda #0 
        cmp #LOGO_APPEAR_DELAY
        beq !+
        rts 
!:
        lda #0 
        sta ftk+1
        ldx #$28 
!:
page_src:
        lda logo,x
        bne noendp
        rts 
noendp:
screen_dst:
        sta screen,x 

        dex 
        bpl !-

        clc
        lda page_src+1
        adc #$28 
        sta page_src+1
        bcc !+
        inc page_src+2
!:
        clc
        lda screen_dst+1
        adc #$28 
        sta screen_dst+1
        bcc !+
        inc screen_dst+2
!:
        inc row_ct+1
row_ct:
        lda #0 
        cmp #25 
        bne !+
        lda #$2c //bit 
        sta screen_fn

        lda #$20 //jsr 
        sta headline_fn
!:
        rts

.import source("data/text.asm")


