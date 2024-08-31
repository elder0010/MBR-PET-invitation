.const screen = $8000
.const basic_upstart = $401
.const VIA_PORT_B = $e840

.const HEADLINE_ADDR = screen+$28*18
.const SUBTITLE_ADDR = screen+$28*20
.const SCROLLTEXT_POS = screen+$28*23

.const LOGO_APPEAR_DELAY = 4
.const SUBTITLE_DELAY = $60
.const SCROLLER_WAIT_TIME = $f0
.const SCROLLTEXT_DELAY = 8