# ~/.config/dooit/config.py
# Parity target: ~/.config/nvim/colors/aubergine.lua (UI) + lua/plugins/colorly.lua (syntax palette)
# Icons: MDI (Nerd Fonts), same spirit as dooit-extras formatters
# https://dooit-org.github.io/dooit-extras/widgets/status_icons.html

from datetime import datetime, timedelta
from typing import Optional

from rich.style import Style
from rich.text import Text

from dooit.api import Todo, Workspace
from dooit.api.theme import DooitThemeBase
from dooit.ui.api import DooitAPI, subscribe
from dooit.ui.api.events import Startup
from dooit.ui.api.widgets import TodoWidget
from dooit_extras.bar_widgets import Clock, Mode, Spacer, StatusIcons, TextBox
from dooit_extras.formatters import (
    description_highlight_tags,
    due_casual_format,
    due_icon,
    status_icons,
    todo_description_progress,
    urgency_icons,
)
from dooit_extras.scripts import toggle_workspaces
from dooit.ui.widgets.inputs.model_inputs import Recurrence
from dooit.ui.widgets.trees.base_tree import BaseTree
from dooit.ui.widgets.trees.model_tree import ModelTree

# Backgrounds + text from ~/.config/nvim/colors/aubergine.lua; syntax/chroma from lua/plugins/colorly.lua (parity with terminal).
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

REC_ICON = "\U000f0456"
ICON_WS = "\U000f024b"
_ZWSP = "\u200b"

_EXTRA_TCSS = f"""
Screen {{
    background: transparent;
}}

* {{
    background: transparent;
}}

BarBase {{
    background: $background2;
    color: $foreground3;
}}

ModelTree {{
    border: heavy {BG4};
    color: $foreground3;
}}

ModelTree:focus {{
    border: heavy $primary;
}}

ModelTree:focus .option-list--option-highlighted,
ModelTree:focus .option-list--option-hover-highlighted {{
    background: $background3;
    color: $foreground3;
}}

ModelTree .option-list--option-hover {{
    background: $background1;
    color: $foreground3;
}}

Header {{
    border: tall {BG4};
    color: $foreground3;
}}

Dashboard {{
    border: heavy {BG4};
}}

DooitKeyTable {{
    background: $background2;
    border: blank $secondary;
    border-title-background: $primary;
    border-title-color: $background1;
}}

DooitKeyTable .keybind {{
    color: $primary;
}}

DooitKeyTable .arrow {{
    color: $foreground1 60%;
}}

DooitKeyTable .description {{
    color: $secondary;
    text-style: bold;
}}

DooitKeyTable .table-title {{
    color: $background3;
    background: $primary;
}}

Outro .thanks {{
    color: $foreground1;
}}

Outro .github {{
    color: $primary;
}}

Outro .exit {{
    background: $primary;
    color: $background1;
}}

SortBar .option-highlighted {{
    background: $secondary;
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


def _count_sub_todos(t: Todo) -> int:
    return sum(1 + _count_sub_todos(c) for c in t.todos)


def _count_workspace_todos(ws: Workspace) -> int:
    n = sum(1 + _count_sub_todos(c) for c in ws.todos)
    for c in ws.workspaces:
        n += _count_workspace_todos(c)
    return n


def workspace_description_formatter(desc: str, model: Workspace, api: DooitAPI):
    if not desc:
        return desc
    theme = api.vars.theme
    n = _count_workspace_todos(model)
    suffix = f" ({n})"
    return (
        Text()
        + Text(ICON_WS + " ", style=Style(color=theme.blue))
        + Text(desc)
        + Text(suffix, style=Style(color=theme.foreground1))
    )


def todo_recurrence_formatter(recurrence: Optional[timedelta], model: Todo, api: DooitAPI):
    if recurrence is None:
        return _ZWSP

    theme = api.vars.theme
    body = Recurrence.timedelta_to_simple_string(recurrence)
    return Text() + Text(REC_ICON + " ", style=Style(color=theme.primary)) + Text(body)


def todo_effort_formatter(effort: object, _: Todo, api: DooitAPI):
    try:
        n = int(effort)
    except (TypeError, ValueError):
        return _ZWSP
    if n == 0:
        return _ZWSP
    return str(n)


def _expand_all_nodes():
    def mark_ws(ws: Workspace):
        BaseTree.expanded_nodes[ws.uuid] = True
        for t in ws.todos:
            mark_todo(t)
        for c in ws.workspaces:
            mark_ws(c)

    def mark_todo(t: Todo):
        BaseTree.expanded_nodes[t.uuid] = True
        for c in t.todos:
            mark_todo(c)

    root = Workspace._get_or_create_root()
    for ws in root.workspaces:
        mark_ws(ws)


def _refresh_all_trees(api: DooitAPI):
    try:
        for tree in api.app.query(ModelTree):
            tree.force_refresh()
    except Exception:
        pass


def _expand_descendant_workspaces(ws: Workspace):
    for c in ws.workspaces:
        BaseTree.expanded_nodes[c.uuid] = True
        _expand_descendant_workspaces(c)


def _expand_descendant_todos(t: Todo):
    for c in t.todos:
        BaseTree.expanded_nodes[c.uuid] = True
        _expand_descendant_todos(c)


def _make_toggle_expand_nested(api: DooitAPI):
    from dooit.ui.widgets.trees import TodosTree, WorkspacesTree

    def toggle_expand_nested():
        tree = api.focused
        model = tree.current_model
        mid = model.uuid
        was_open = tree.is_node_expaned(mid)
        tree.toggle_expand()
        if not was_open:
            if isinstance(tree, WorkspacesTree):
                _expand_descendant_workspaces(model)
            elif isinstance(tree, TodosTree):
                _expand_descendant_todos(model)
            tree.force_refresh()

    return toggle_expand_nested


@subscribe(Startup)
def use_aubergine_theme(api: DooitAPI, _: Startup):
    api.css.add_theme(AubergineTheme)
    api.css.set_theme("aubergine")
    api.css.inject_css(_EXTRA_TCSS.strip(), _id="nvim-aubergine-ui")

    theme = api.vars.theme
    fmt = api.formatter

    fmt.todos.status.formatters.clear()
    fmt.todos.due.formatters.clear()
    fmt.todos.urgency.formatters.clear()
    fmt.todos.description.formatters.clear()
    fmt.todos.recurrence.formatters.clear()
    fmt.todos.effort.formatters.clear()
    fmt.workspaces.description.formatters.clear()

    fmt.workspaces.description.add(workspace_description_formatter)

    fmt.todos.status.add(status_icons(completed=" ", pending="󰞋 ", overdue="󰅗 "))
    fmt.todos.urgency.add(
        urgency_icons(icons={1: "  󰎤", 2: "  󰎧", 3: "  󰎪", 4: "  󰎭"})
    )
    fmt.todos.due.add(due_casual_format())
    fmt.todos.due.add(due_icon(completed=" ", pending=" ", overdue=" "))
    fmt.todos.description.add(
        todo_description_progress(
            fmt=Text("  {completed_count}/{total_count}", style=theme.green).markup
        )
    )
    fmt.todos.description.add(description_highlight_tags(fmt=" {}"))
    fmt.todos.recurrence.add(todo_recurrence_formatter)
    fmt.todos.effort.add(todo_effort_formatter)

    api.layouts.todo_layout = [
        TodoWidget.status,
        TodoWidget.description,
        TodoWidget.due,
        TodoWidget.urgency,
        TodoWidget.recurrence,
        TodoWidget.effort,
    ]

    api.vars.always_expand_workspaces = False
    api.vars.always_expand_todos = False
    BaseTree.expanded_nodes.clear()
    _expand_all_nodes()

    def apply_tree_state():
        _expand_all_nodes()
        _refresh_all_trees(api)

    api.app.set_timer(0.05, apply_tree_state, name="dooit-start-expanded")

    api.keys.set(
        "z",
        _make_toggle_expand_nested(api),
        description="Toggle expand; expands nested workspaces or todos when opening",
    )

    api.bar.set(
        [
            Mode(api),
            Spacer(api, width=0),
            StatusIcons(api, bg=theme.background2),
            TextBox(api, text="  ", bg=theme.primary),
            TextBox(api, text=" -4°C ", fg=theme.foreground3, bg=theme.background3),
            TextBox(api, text=" 󰥔 ", bg=theme.primary),
            Clock(
                api,
                format="%I:%M %p",
                fg=theme.foreground3,
                bg=theme.background3,
            ),
        ]
    )

    now = datetime.now()
    formatted_date = now.strftime(" 󰸘 %A, %d %b ")
    header = Text(
        "I alone shall stand against the darkness of my overdue tasks",
        style=Style(color=theme.primary, bold=True, italic=True),
    )
    ascii_art = r"""
                     .
                    / V\
                  / `  /
                 <<   |
                 /    |
               /      |
             /        |
           /    \  \ /
          (      ) | |
  ________|   _/_  | |
<__________\______)\__)
    """
    api.dashboard.set(
        [
            header,
            "",
            Text(ascii_art, style=theme.primary),
            "",
            Text(
                formatted_date,
                style=Style(color=theme.secondary, bold=True, italic=True),
            ),
        ]
    )


# https://dooit-org.github.io/dooit-extras/scripts/toggle_workspaces.html
@subscribe(Startup)
def setup(api: DooitAPI, _: Startup):
    api.keys.set("<ctrl+b>", toggle_workspaces(api))
