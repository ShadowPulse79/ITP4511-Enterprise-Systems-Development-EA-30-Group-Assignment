<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.leese.cchcsystem.model.entity.Notification" %>
<%
  List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
  Integer unreadCount = (Integer) request.getAttribute("unreadCount");
  if (unreadCount == null) unreadCount = 0;
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>我的通知 - CCHC诊所系统</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: 'Microsoft YaHei', Arial, sans-serif; background: #f5f5f5; padding: 20px; }
    .container { max-width: 800px; margin: 0 auto; }
    .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 15px 20px; border-radius: 10px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
    .header h2 { font-size: 20px; }
    .header a { color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 5px 12px; border-radius: 5px; }
    .stats { background: white; padding: 15px; border-radius: 10px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
    .unread-badge { background: #e74c3c; color: white; padding: 5px 12px; border-radius: 20px; font-size: 14px; }
    .btn-mark-all { background: #3498db; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; }
    .notification-list { background: white; border-radius: 10px; overflow: hidden; }
    .notification-item { padding: 15px 20px; border-bottom: 1px solid #eee; transition: background 0.2s; }
    .notification-item:hover { background: #f9f9f9; }
    .notification-item.unread { background: #f0f7ff; border-left: 4px solid #3498db; }
    .notification-title { font-weight: bold; margin-bottom: 5px; display: flex; justify-content: space-between; }
    .notification-type { font-size: 12px; color: #667eea; }
    .notification-message { color: #555; margin-bottom: 8px; line-height: 1.4; }
    .notification-time { font-size: 12px; color: #999; }
    .notification-actions { margin-top: 8px; }
    .notification-actions a { font-size: 12px; color: #3498db; text-decoration: none; margin-right: 10px; }
    .empty { text-align: center; padding: 40px; color: #999; }
    .back-link { display: inline-block; margin-top: 20px; color: #667eea; text-decoration: none; }
  </style>
</head>
<body>
<div class="container">
  <div class="header">
    <h2>🔔 我的通知</h2>
    <a href="${pageContext.request.contextPath}/user/profile">← 返回个人中心</a>
  </div>

  <div class="stats">
    <span>📬 通知列表</span>
    <span class="unread-badge">未读 <%= unreadCount %> 条</span>
    <% if (unreadCount > 0) { %>
    <form action="${pageContext.request.contextPath}/notification/markAllRead" method="post" style="display: inline;">
      <button type="submit" class="btn-mark-all">全部标记已读</button>
    </form>
    <% } %>
  </div>

  <div class="notification-list">
    <%
      if (notifications == null || notifications.isEmpty()) {
    %>
    <div class="empty">📭 暂无通知</div>
    <%
    } else {
      for (Notification n : notifications) {
        String rowClass = n.isRead() ? "" : "unread";
    %>
    <div class="notification-item <%= rowClass %>" id="notify-<%= n.getId() %>">
      <div class="notification-title">
        <span><%= n.getTitle() %></span>
        <span class="notification-type"><%= n.getTypeName() %></span>
      </div>
      <div class="notification-message"><%= n.getMessage() %></div>
      <div class="notification-time"><%= n.getCreatedAt() %></div>
      <div class="notification-actions">
        <% if (!n.isRead()) { %>
        <a href="javascript:markRead(<%= n.getId() %>)">标记已读</a>
        <% } %>
        <a href="javascript:deleteNotify(<%= n.getId() %>)" style="color: #e74c3c;">删除</a>
      </div>
    </div>
    <%
        }
      }
    %>
  </div>

  <a href="${pageContext.request.contextPath}/user/profile" class="back-link">← 返回个人中心</a>
</div>

<script>
  function markRead(id) {
    fetch('${pageContext.request.contextPath}/notification/markRead?id=' + id, {
      method: 'POST'
    })
            .then(response => response.json())
            .then(data => {
              if (data.success) {
                location.reload();
              }
            });
  }

  function deleteNotify(id) {
    if (confirm('确定删除这条通知吗？')) {
      window.location.href = '${pageContext.request.contextPath}/notification/delete?id=' + id;
    }
  }
</script>
</body>
</html>