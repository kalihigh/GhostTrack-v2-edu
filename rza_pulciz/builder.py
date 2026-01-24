import os, shutil, uuid
from typing import Dict, Any, Tuple
from .schemas import PanelPlan, ActionType

BASE_DIR = os.path.dirname(os.path.dirname(__file__))
SESSIONS_DIR = os.path.join(BASE_DIR, "var", "rza_sessions")

def _ensure_sessions_dir():
    os.makedirs(SESSIONS_DIR, exist_ok=True)

def _run_script(script_path: str, args: Any) -> str:
    return f"[RZA] run {script_path} args={args}"

def _read_file(path: str) -> str:
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

def build(plan: PanelPlan) -> Tuple[str, Dict[str, Any]]:
    _ensure_sessions_dir()
    session_id = str(uuid.uuid4())
    session_dir = os.path.join(SESSIONS_DIR, session_id)
    os.makedirs(session_dir, exist_ok=True)

    html, logs, extra = "", "", {}

    for action in plan.actions:
        if action.type == ActionType.RUN_SCRIPT:
            logs += "\n" + _run_script(action.params["script"], action.params.get("args", []))
        elif action.type == ActionType.RENDER_TEMPLATE:
            html += _read_file(action.params["template_path"])
        elif action.type == ActionType.ATTACH_LOG:
            if os.path.exists(action.params["log_path"]):
                logs += "\n" + _read_file(action.params["log_path"])

    with open(os.path.join(session_dir, "manifest.txt"), "w") as f:
        f.write(f"panel_type={plan.panel_type}\n")

    return session_id, {"html": html, "logs": logs, "extra": extra}
