@app.route("/callback", methods=["POST"])
def callback():
    # 验证Token
    if request.headers.get("Authorization") != "Bearer your_token_here":
        return jsonify({"status": "unauthorized"}), 403

    data = request.json
    message = data.get("message")
    user_id = data.get("user_id")
    group_id = data.get("group_id")

    if "集训" in message:
        print(f"检测到关键词：{message}")

    return jsonify({"status": "ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)