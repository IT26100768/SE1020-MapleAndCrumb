package com.mapleandcrumb.servlet.comp05;

import com.mapleandcrumb.dao.comp05.KitchenTaskDAO;
import com.mapleandcrumb.dao.comp05.StaffDAO;
import com.mapleandcrumb.dao.impl.comp05.KitchenTaskDAOImpl;
import com.mapleandcrumb.dao.impl.comp05.StaffDAOImpl;
import com.mapleandcrumb.model.comp05.KitchenTask;
import com.mapleandcrumb.model.comp05.Staff;
import com.mapleandcrumb.util.ParamUtil;
import com.mapleandcrumb.util.SecurityUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({
        "/kitchenQueue",
        "/kitchen_queue",
        "/comp05-admin/kitchenQueue",
        "/comp05-admin/kitchen_queue"
})
public class KitchenQueueServlet extends HttpServlet {

    private final KitchenTaskDAO kitchenTaskDAO = new KitchenTaskDAOImpl();
    private final StaffDAO staffDAO = new StaffDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireStaffOrAdmin(request, response)) {
            return;
        }

        String dateFilter = ParamUtil.getTrimmed(request, "date", "all");
        String channelFilter = ParamUtil.getTrimmed(request, "channel", "all");
        String stageFilter = ParamUtil.getTrimmed(request, "stage", "all");
        String keyword = ParamUtil.getTrimmed(request, "q");

        List<KitchenTask> tasks = kitchenTaskDAO.getTasksByFilter(dateFilter, channelFilter, stageFilter, keyword);
        List<Staff> staffList = staffDAO.getAllStaff();

        request.setAttribute("tasks", tasks);
        request.setAttribute("staffList", staffList);
        request.setAttribute("todayCount", kitchenTaskDAO.getTodayTaskCount());
        request.setAttribute("tomorrowCount", kitchenTaskDAO.getTomorrowTaskCount());
        request.setAttribute("cakeInPrepCount", kitchenTaskDAO.getCustomCakesInPrepCount());
        request.setAttribute("overdueCount", kitchenTaskDAO.getOverdueTaskCount());
        request.setAttribute("currentDateFilter", dateFilter);
        request.setAttribute("currentChannelFilter", channelFilter);
        request.setAttribute("currentStageFilter", stageFilter);
        request.setAttribute("searchKeyword", keyword);

        request.getRequestDispatcher("/comp05-admin/kitchen_queue.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireStaffOrAdmin(request, response)) {
            return;
        }

        String action = ParamUtil.getTrimmed(request, "action");
        int taskId = ParamUtil.getInt(request, "taskId", -1);
        if (taskId <= 0) {
            response.sendRedirect(request.getContextPath() + "/kitchenQueue?error=invalid_task");
            return;
        }

        if ("assignBaker".equalsIgnoreCase(action)) {
            String bakerIdStr = ParamUtil.getTrimmed(request, "bakerId");
            Integer bakerId = null;
            if (bakerIdStr != null && !"-1".equals(bakerIdStr)) {
                try (java.sql.Connection conn = com.mapleandcrumb.util.DBUtil.getConnection()) {
                    bakerId = com.mapleandcrumb.util.DBUtil.findUserIdByCodeOrId(conn, bakerIdStr);
                } catch (java.sql.SQLException e) {
                    System.err.println("KitchenQueueServlet: Error resolving baker ID: " + e.getMessage());
                }
            }
            kitchenTaskDAO.assignBaker(taskId, bakerId);
            respond(request, response, "Baker assigned successfully.", "baker_assigned");
            return;
        } else if ("updateStage".equalsIgnoreCase(action)) {
            String newStage = ParamUtil.getTrimmed(request, "stage");
            if (newStage != null) {
                kitchenTaskDAO.updatePrepStage(taskId, newStage);
            }
            respond(request, response, "Preparation stage updated.", "stage_updated");
            return;
        } else if ("updatePriority".equalsIgnoreCase(action)) {
            String newPriority = ParamUtil.getTrimmed(request, "priority");
            if (newPriority != null) {
                kitchenTaskDAO.updatePriority(taskId, newPriority);
            }
            respond(request, response, "Task priority updated.", "priority_updated");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/kitchenQueue");
    }

    private void respond(HttpServletRequest request, HttpServletResponse response, String message, String redirectMsg) throws IOException {
        if (ParamUtil.isAjax(request)) {
            ParamUtil.writeJson(response, true, message);
        } else {
            response.sendRedirect(request.getContextPath() + "/kitchenQueue?msg=" + redirectMsg);
        }
    }
}
