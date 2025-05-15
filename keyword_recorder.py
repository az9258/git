from flask import Flask, request, jsonify
import datetime

app = Flask(__name__)

@app.route("/", methods=["POST"])
def handle_message():
    data = request.json
    message = data.get("message", "")
    group_id = data.get("group_id")
    user_id = data.get("user_id")


    if is_admin_command(message, user_id):
        return handle_admin_command(message, group_id)


    matched_keyword = detect_keyword(message)
    if matched_keyword:
        log_keyword_trigger(group_id, user_id, matched_keyword, message)

    return jsonify({"status": "ok"})

def detect_keyword(message):
    session = Session()
    keywords = session.query(Keyword).filter(Keyword.is_active).all()
    for kw in keywords:
        if kw.keyword in message:
            return kw.keyword
    return None

def log_keyword_trigger(group_id, user_id, keyword, content):
    session = Session()
    log = KeywordLog(
        group_id=group_id,
        user_id=user_id,
        keyword=keyword,
        content=content,
        created_at=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    )
    session.add(log)
    session.commit()

def is_admin_command(message, user_id):
    return message.startswith("!keyword") and is_admin(user_id)

def is_admin(user_id):

    return user_id in [123456, 654321]  # 替换为你的QQ号

def handle_admin_command(message, group_id):
    session = Session()
    parts = message.split()
    if len(parts) < 2:
        return jsonify({"error": "格式错误，正确用法：!keyword add/del/list [关键词]"})

    cmd = parts[1]
    if cmd == "add" and len(parts) >= 3:
        keyword = parts[2]
        if session.query(Keyword).filter(Keyword.keyword == keyword).first():
            return jsonify({"error": "关键词已存在"})
        session.add(Keyword(keyword=keyword))
        session.commit()
        return jsonify({"reply": f"关键词 [{keyword}] 已添加"})

    elif cmd == "del" and len(parts) >= 3:
        keyword = parts[2]
        kw = session.query(Keyword).filter(Keyword.keyword == keyword).first()
        if not kw:
            return jsonify({"error": "关键词不存在"})
        session.delete(kw)
        session.commit()
        return jsonify({"reply": f"关键词 [{keyword}] 已删除"})

    elif cmd == "list":
        keywords = session.query(Keyword).all()
        kw_list = "\n".join([kw.keyword for kw in keywords])
        return jsonify({"reply": f"当前关键词列表：\n{kw_list}"})

    else:
        return jsonify({"error": "未知命令，可用：add/del/list"})
    
