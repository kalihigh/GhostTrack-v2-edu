from dataclasses import dataclass
from enum import Enum
from typing import Dict, Any, List, Optional

class PanelType(str, Enum):
    LEDGER_PANEL = "LEDGER_PANEL"
    ECO_LOG_PANEL = "ECO_LOG_PANEL"
    PODCAST_LIBERI_PANEL = "PODCAST_LIBERI_PANEL"
    AGENTS_STATUS_PANEL = "AGENTS_STATUS_PANEL"
    RITUALI_PRAGONE_PANEL = "RITUALI_PRAGONE_PANEL"

class ActionType(str, Enum):
    RUN_SCRIPT = "RUN_SCRIPT"
    RENDER_TEMPLATE = "RENDER_TEMPLATE"
    ATTACH_LOG = "ATTACH_LOG"
    SHOW_FORM = "SHOW_FORM"

@dataclass
class Action:
    type: ActionType
    params: Dict[str, Any]

@dataclass
class PanelPlan:
    panel_type: PanelType
    scripts: List[str]
    template: Optional[str]
    actions: List[Action]
    extra_context: Dict[str, Any]
