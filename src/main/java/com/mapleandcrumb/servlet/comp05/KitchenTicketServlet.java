
package com.mapleandcrumb.servlet.comp05;

import com.mapleandcrumb.dao.comp03.CustomCakeDAO;
import com.mapleandcrumb.dao.comp04.OrderDAO;
import com.mapleandcrumb.dao.comp05.KitchenTaskDAO;
import com.mapleandcrumb.dao.comp05.StaffDAO;
import com.mapleandcrumb.dao.impl.comp03.CustomCakeDAOImpl;
import com.mapleandcrumb.dao.impl.comp04.OrderDAOImpl;
import com.mapleandcrumb.dao.impl.comp05.KitchenTaskDAOImpl;
import com.mapleandcrumb.dao.impl.comp05.StaffDAOImpl;
import com.mapleandcrumb.model.comp03.CustomCakeOrder;
import com.mapleandcrumb.model.comp04.DeliveryOrder;
import com.mapleandcrumb.model.comp04.Order;
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
import java.time.LocalDateTime;
import java.util.List;

@WebServlet({
        "/kitchenTicket",
        "/kitchen_ticket",
        "/printTicket",
        "/comp05-admin/kitchenTicket",
        "/comp05-admin/kitchen_ticket"
})
public class KitchenTicketServlet extends HttpServlet {

    private final KitchenTaskDAO kitchenTaskDAO = new KitchenTaskDAOImpl();
    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final CustomCakeDAO customCakeDAO = new CustomCakeDAOImpl();
    private final StaffDAO staffDAO = new StaffDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!SecurityUtil.requireStaffOrAdmin(request, response)) {
            return;
        }

        Integer taskId = ParamUtil.getInteger(request, "taskId");
        String orderIdStr = ParamUtil.getTrimmed(request, "orderId");
        String cakeIdStr = ParamUtil.getTrimmed(request, "cakeId");

        KitchenTask task = null;
        if (taskId != null) {
            task = kitchenTaskDAO.getTaskById(taskId);
        }

        if (task == null && orderIdStr != null) {
            Integer numOrderId = ParamUtil.getInteger(request, "orderId");
            if (numOrderId != null) {
                task = kitchenTaskDAO.getTaskByOrderId(numOrderId);
            }

            if (task == null) {
                Order order = orderDAO.getOrderById(orderIdStr);
                if (order != null) {
                    task = new KitchenTask();
                    task.setTaskType("ORDER");
                    task.setOrderCode(order.getOrderId());
                    task.setCustomerName(order.getCustomerId());
                    task.setFulfillmentType(order instanceof DeliveryOrder ? "Delivery" : "Pickup");
                    if (order instanceof DeliveryOrder) {
                        task.setDeliveryAddress(((DeliveryOrder) order).getDeliveryAddress());
                    }
                    task.setItems(order.getItems());
                    task.setDueDatetime(LocalDateTime.now().plusHours(2));
                    task.setTimeSlot("Immediate Batch Window");
                    task.setPrepStage(order.getStatus());
                    task.setTotalAmount(order.calculateFinalTotal());
                }
            }
        }

        if (task == null && cakeIdStr != null) {
            Integer numCakeId = ParamUtil.getInteger(request, "cakeId");
            if (numCakeId != null) {
                task = kitchenTaskDAO.getTaskByCustomRequestId(numCakeId);
            }

            if (task == null) {
                CustomCakeOrder cake = customCakeDAO.getBookingById(cakeIdStr);
                if (cake != null) {
                    task = new KitchenTask();
                    task.setTaskType("CUSTOM_CAKE");
                    task.setBookingCode(cake.getBookingId());
                    task.setCustomerName(cake.getCustomerId());
                    task.setFulfillmentType("Pickup");
                    task.setCustomCakeFlavor(cake.getFlavor());
                    task.setCustomCakeSizeInches(cake.getSizeInches());
                    task.setCustomCakeMessage(cake.getCustomMessage());
                    task.setDueDatetime(cake.getPickupDate() != null ? cake.getPickupDate().atTime(12, 0) : LocalDateTime.now().plusDays(2));
                    task.setTimeSlot("Afternoon Slot");
                    task.setPrepStage(cake.getStatus());
                    task.setTotalAmount(cake.calculateBasePrice());
                    task.setPriority("HIGH");
                }
            }
        }

        String paymentMethod = "Counter / Card Payment";
        String paymentStatus = "CLEARED";
        if (task != null) {
            if ("CUSTOM_CAKE".equalsIgnoreCase(task.getTaskType())) {
                paymentMethod = "Counter Collection";
                paymentStatus = "PENDING_AT_COUNTER";
            } else if (task.getOrderCode() != null) {
                paymentMethod = orderDAO.getPaymentMethod(task.getOrderCode());
                paymentStatus = "COMPLETED";
            }
        }

        List<Staff> staffList = staffDAO.getAllStaff();
        request.setAttribute("staffList", staffList);
        request.setAttribute("paymentMethod", paymentMethod);
        request.setAttribute("paymentStatus", paymentStatus);
        request.setAttribute("task", task);
        request.getRequestDispatcher("/comp05-admin/kitchen_ticket.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
