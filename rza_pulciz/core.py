from typing import Dict, Any
from . import brain, builder, janitor
from .schemas import PanelType

def invoke(panel_type_str: str, context: Dict[str, Any]) -> Dict[str, Any]:
    panel_type = PanelType(panel_type_str)
    plan = brain.plan(panel_type, context)
    session_id, payload = builder.build(plan)
    return {"session_id": session_id, "payload": payload}

def cleanup(session_id: str) -> Dict[str, Any]:
    ok = janitor.cleanup(session_id)
    return {"status": "ok" if ok else "error"}
