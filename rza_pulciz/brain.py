import os
from typing import Dict, Any
from .schemas import PanelType, ActionType, Action, PanelPlan

BASE_DIR = os.path.dirname(os.path.dirname(__file__))

def plan(panel_type: PanelType, context: Dict[str, Any]) -> PanelPlan:
    if panel_type == PanelType.LEDGER_PANEL:
        scripts = [os.path.join(BASE_DIR, "scripts", "eco_ledger.sh")]
        template = os.path.join(BASE_DIR, "webapp", "static", "templates", "ledger_base.html")
        actions = [
            Action(type=ActionType.RUN_SCRIPT, params={"script": scripts[0], "args": context.get("args", [])}),
            Action(type=ActionType.RENDER_TEMPLATE, params={"template_path": template}),
            Action(type=ActionType.ATTACH_LOG, params={"log_path": os.path.join(BASE_DIR, "var", "rza_ledger.log")}),
        ]
        return PanelPlan(panel_type, scripts, template, actions, context)

    return PanelPlan(panel_type, [], None, [], context)
