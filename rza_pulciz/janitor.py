import os, shutil
from datetime import datetime

BASE_DIR = os.path.dirname(os.path.dirname(__file__))
SESSIONS_DIR = os.path.join(BASE_DIR, "var", "rza_sessions")
LEDGER_PATH = os.path.join(BASE_DIR, "var", "rza_ledger.log")

def cleanup(session_id: str) -> bool:
    session_dir = os.path.join(SESSIONS_DIR, session_id)
    ok = True

    if os.path.exists(session_dir):
        try: shutil.rmtree(session_dir)
        except: ok = False

    with open(LEDGER_PATH, "a") as f:
        f.write(f"{datetime.utcnow().isoformat()}Z CLEANUP {session_id} ok={ok}\n")

    return ok
