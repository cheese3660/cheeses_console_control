module cheeses_console_control::conctrl;
import std::io;


def CommandBuffer = DString;

CommandBuffer buffer;

fn void setup() @init {
    buffer.new_init();
}

fn void free() @finalizer {
    buffer.free();
}

fn void flush() {
    io::print(buffer.str_view());
    buffer.clear();
}


fn void print(String s) {
    buffer.append(s);
}

fn void printf(String format, args...) {
    buffer.appendf(format, ...args);
}

macro @csi_format(#format, args...) {
    buffer.appendf("\x1B[" +++ #format, ...args);
}

fn void up(int n=1) {
    @csi_format("%dA", n);
}

fn void down(int n=1) {
    @csi_format("%dB", n);
}

fn void right(int n=1) {
    @csi_format("%dC", n);
}

fn void left(int n=1) {
    @csi_format("%dD", n);
}

fn void next_line(int n=1) {
    @csi_format("%dE", n);
}

fn void previous_line(int n=1) {
    @csi_format("%dF", n);
}

fn void goto_column(int c=1) {
    @csi_format("%dG", c);
}

fn void goto(int row = 1, int column = 1) {
    @csi_format("%d;%dH", row, column);
}

enum EraseMode : (int number) {
    CURSOR_TO_END = 0,
    CURSOR_TO_BEGINNING = 1,
    ALL = 2,
    ALL_AND_SCROLLBUFFER = 3
}

fn void erase(EraseMode mode = CURSOR_TO_END) {
    @csi_format("%dJ", mode.number);
}

fn void erase_line(EraseMode mode = CURSOR_TO_END) {
    @csi_format("%dK", mode.number);
}

fn void scroll_up(int lines) {
    @csi_format("%dS", lines);
}

fn void scroll_down(int lines) {
    @csi_format("%dT", lines);
}

macro @sgi_format(#format, int n, args...) {
    buffer.appendf("\x1b[%d", n);
    $if $vacount > 0:
        buffer.appendf(#format, ...args);
    $endif
    buffer.append('m');
}

enum GraphicsRendition : (int n) {
    RESET = 0,
    BOLD = 1,
    FAINT = 2,
    ITALIC = 3,
    UNDERLINE = 4,
    SLOW_BLINK = 5,
    RAPID_BLINK = 6,
    REVERSE_VIDEO = 7,
    CONCEAL = 8,
    STRIKETHROUGH = 9,
    DEFAULT_FONT = 10,
    ALTERNATIVE_FONT_1 = 11,
    ALTERNATIVE_FONT_2 = 12,
    ALTERNATIVE_FONT_3 = 13,
    ALTERNATIVE_FONT_4 = 14,
    ALTERNATIVE_FONT_5 = 15,
    ALTERNATIVE_FONT_6 = 16,
    ALTERNATIVE_FONT_7 = 17,
    ALTERNATIVE_FONT_8 = 18,
    ALTERNATIVE_FONT_9 = 19,
    FRAKTUR = 20,
    DOUBLE_UNDERLINE = 21,
    NORMAL_INTENSITY = 22,
    NOT_ITALIC = 23,
    NOT_UNDERLINED = 24,
    NOT_BLINKING = 25,
    NOT_REVERSED = 27,
    NOT_CONCEALED = 28,
    NOT_CROSSED_OUT = 29,
    DEFAULT_FOREGROUND = 39,
    DEFAULT_BACKGROUND = 49,
    FRAMED = 51,
    ENCIRCLED = 52,
    OVERLINED = 53,
    SUPERSCRIPT = 73,
    SUBSCRIPT = 74,
    NORMAL_SCRIPT = 75,
}

fn void sgi(GraphicsRendition rendition) {
    @sgi_format("",rendition.n);
}

enum TerminalColor : (int base) {
    BLACK = 0,
    DARK_RED = 1,
    DARK_GREEN = 2,
    DARK_YELLOW = 3,
    DARK_BLUE = 4,
    DARK_MAGENTA = 5,
    DARK_CYAN = 6,
    GRAY = 7,
    DARK_GRAY = 60,
    RED = 61,
    GREEN = 62,
    YELLOW = 63,
    BLUE = 64,
    MAGENTA = 65,
    CYAN = 66,
    WHITE = 67
}

fn void fg(TerminalColor c) {
    @sgi_format("", c.base + 30);
}

fn void bg(TerminalColor c) {
    @sgi_format("", c.base + 40);
}

fn void reset_fg() {
    sgi(DEFAULT_FOREGROUND);
}

fn void reset_bg() {
    sgi(DEFAULT_BACKGROUND);
}

fn void fg_pallete(int index) {
    @sgi_format(";5;%d", 38, index);
}

fn void bg_pallete(int index) {
    @sgi_format(";5;%d", 48, index);
}

fn void fg_rgb(char r, char g, char b) {
    @sgi_format(";2;%d;%d;%d", 38, r, g, b);
}

fn void bg_rgb(char r, char g, char b) {
    @sgi_format(";2;%d;%d;%d", 48, r, g, b);
}