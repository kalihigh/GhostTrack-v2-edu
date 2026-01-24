from flask import Blueprint, request, jsonify
from rza_pulciz import core

rza_bp = Blueprint("rza", __name__, url_prefix="/rza")

@rza_bp.route("/invoke", methods=["POST"])
def rza_invoke():
    data = request.get_json(force=True) or {}
    panel_type = data.get("panel_type")
    context = data.get("context", {})
    if not panel_type:
        return jsonify({"error": "panel_type required"}), 400
    return jsonify(core.invoke(panel_type, context))

@rza_bp.route("/cleanup", methods=["POST"])
def rza_cleanup():
    data = request.get_json(force=True) or {}
    session_id = data.get("session_id")
    if not session_id:
        return jsonify({"error": "session_id required"}), 400
    return jsonify(core.cleanup(session_id))
