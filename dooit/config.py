# ~/.config/dooit/config.py
# Parity target: ~/.config/nvim/colors/aubergine.lua (UI) + lua/plugins/colorly.lua (syntax palette)

from dooit.api.theme import DooitThemeBase
from dooit.ui.api import DooitAPI, subscribe
from dooit.ui.api.events import Startup

# colors_override in aubergine.lua
BG1 = "#3E313C"
BG2 = "#261C25"
BG3 = "#4F384A"
BG4 = "#523F4D"
TEXT = "#F6F6F4"
TEXT_DIM1 = "#B9B9B9"
ALPHA = "#82AAFF"
BETA = "#80CBC4"
DELTA = "#F44C5E"
EPSILON = "#FFCB6B"
ZETA = "#F78C6C"
ETA = "#C3E88D"
IOTA = "#C792EA"
ACCENT1 = "#3E9689"

_EXTRA_TCSS = f"""
Screen {{
    background: transparent;
}}

* {{
    background: transparent;
}}

BarBase {{
    background: {ACCENT1};
    color: {TEXT};
}}

ModelTree {{
    border: heavy {BG4};
    color: {TEXT};
}}

ModelTree:focus {{
    border: heavy {ACCENT1};
}}

ModelTree:focus .option-list--option-highlighted,
ModelTree:focus .option-list--option-hover-highlighted {{
    background: {BG3};
    color: {TEXT};
}}

ModelTree .option-list--option-hover {{
    background: {BG1};
    color: {TEXT};
}}

Header {{
    border: tall {BG4};
}}

Dashboard {{
    border: heavy {BG4};
}}

DooitKeyTable {{
    background: {BG3};
}}

SortBar .option-highlighted {{
    background: {BG4};
}}
"""


class AubergineTheme(DooitThemeBase):
    _name = "aubergine"

    background1 = BG1
    background2 = BG2
    background3 = BG3

    foreground1 = TEXT_DIM1
    foreground2 = TEXT
    foreground3 = TEXT

    red = DELTA
    orange = ZETA
    yellow = EPSILON
    green = ETA
    blue = ALPHA
    purple = IOTA
    magenta = IOTA
    cyan = BETA

    primary = ACCENT1
    secondary = ALPHA


@subscribe(Startup)
def use_aubergine_theme(api: DooitAPI, _: Startup):
    api.css.add_theme(AubergineTheme)
    api.css.set_theme("aubergine")
    api.css.inject_css(_EXTRA_TCSS.strip(), _id="nvim-aubergine-ui")
