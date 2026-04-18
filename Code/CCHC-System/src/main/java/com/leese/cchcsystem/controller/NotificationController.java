package com.leese.cchcsystem.controller;

import com.leese.cchcsystem.model.entity.Notification;
import com.leese.cchcsystem.service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet({
        "/notification/list",
        "/notification/count",
        "/notification/markRead",
        "/notification/markAllRead",
        "/notification/delete"
})
public class NotificationController extends HttpServlet {
    private NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/notification/list":
                showNotificationList(request, response);
                break;
            case "/notification/count":
                getUnreadCount(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        switch (path) {
            case "/notification/markRead":
                markAsRead(request, response);
                break;
            case "/notification/markAllRead":
                markAllAsRead(request, response);
                break;
            case "/notification/delete":
                deleteNotification(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * 显示通知列表页面
     */
    private void showNotificationList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //不自动创建新会话，只获取已存在的会话
        HttpSession session = request.getSession(false);
        //登录状态校验
        if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }
        //获取session的userId
        int userId = (int) session.getAttribute("userId");
        List<Notification> notifications = notificationService.getUserNotifications(userId);
        int unreadCount = notificationService.getUnreadCount(userId);

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        //请求转发到 JSP，将 request 和 response 传递给 JSP 进行页面渲染
        request.getRequestDispatcher("/WEB-INF/views/notification/list.jsp").forward(request, response);
    }
    /**
     * 标记单条为已读（AJAX）
     */
    private void markAsRead(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"未登录\"}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int notificationId = Integer.parseInt(request.getParameter("id"));

        boolean success = notificationService.markAsRead(notificationId, userId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.write("{\"success\":" + success + "}");
        out.flush();
    }

    /**
     * 全部标记为已读
     */
    private void markAllAsRead(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        notificationService.markAllAsRead(userId);

        // 获取来源页面，返回原页面
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/notification/list");
        }
    }

    /**
     * 删除通知
     */
    private void deleteNotification(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int notificationId = Integer.parseInt(request.getParameter("id"));

        notificationService.deleteNotification(notificationId, userId);

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/notification/list");
        }
    }

    /**
     * 获取未读数量（AJAX）
     */
    private void getUnreadCount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.getWriter().write("{\"count\":0}");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int count = notificationService.getUnreadCount(userId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.write("{\"count\":" + count + "}");
        out.flush();
    }

}
