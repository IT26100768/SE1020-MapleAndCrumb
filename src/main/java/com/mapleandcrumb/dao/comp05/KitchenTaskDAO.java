package com.mapleandcrumb.dao.comp05;

import com.mapleandcrumb.model.comp05.KitchenTask;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Data Access Object interface for managing bakery production tasks in `kitchen_tasks`.
 * Component 5: Production and Kitchen Operations.
 */
public interface KitchenTaskDAO {

    /**
     * Inserts a new kitchen task into the production queue.
     */
    void createTask(KitchenTask task);

    /**
     * Retrieves a task by its primary key ID.
     */
    KitchenTask getTaskById(int taskId);

    /**
     * Retrieves a task associated with a regular order ID.
     */
    KitchenTask getTaskByOrderId(int orderId);

    /**
     * Retrieves a task associated with a custom cake request ID.
     */
    KitchenTask getTaskByCustomRequestId(int customRequestId);

    /**
     * Returns all active tasks in the kitchen queue (excluding COMPLETED and CANCELLED),
     * sorted chronologically by due date and time, with overdue items prioritized.
     */
    List<KitchenTask> getAllActiveTasks();

    /**
     * Returns filtered kitchen tasks based on date, channel, preparation stage, and keyword search.
     */
    List<KitchenTask> getTasksByFilter(String dateFilter, String channelFilter, String stageFilter, String searchKeyword);

    /**
     * Updates the preparation stage of a specific task.
     */
    void updatePrepStage(int taskId, String newStage);

    /**
     * Assigns a staff member / baker to a task.
     */
    void assignBaker(int taskId, Integer bakerUserId);

    /**
     * Updates the operational priority (NORMAL, HIGH, URGENT).
     */
    void updatePriority(int taskId, String newPriority);

    /**
     * Marks the task as CANCELLED when the upstream order or booking is cancelled.
     */
    void cancelTaskBySource(String taskType, int sourceId);

    /**
     * Count of all active tasks in the kitchen operations queue (excluding COMPLETED and CANCELLED).
     */
    int getActiveTaskCount();

    /**
     * Count of active tasks due today.
     */
    int getTodayTaskCount();

    /**
     * Count of active tasks due tomorrow.
     */
    int getTomorrowTaskCount();

    /**
     * Count of custom cakes currently in preparation or pending.
     */
    int getCustomCakesInPrepCount();

    /**
     * Count of active tasks whose due deadline has passed.
     */
    int getOverdueTaskCount();

    /**
     * Convenience enqueue method for regular pastry/cake orders.
     */
    void enqueueOrderTask(int orderId, String orderCode, LocalDateTime dueDateTime, String fulfillmentType, String notes);

    /**
     * Convenience enqueue method for custom cake bookings.
     */
    void enqueueCakeTask(int customRequestId, String bookingCode, LocalDate pickupDate, String timeSlot, String notes);

    /**
     * Synchronizes a regular order's status change with the kitchen queue.
     */
    void syncOrderStatus(String orderIdentifier, String newStatus);

    /**
     * Synchronizes a custom cake booking's status change with the kitchen queue.
     */
    void syncCakeStatus(String bookingIdentifier, String newStatus);

    /**
     * Ensures any registered orders or custom cake requests without kitchen tasks are backfilled.
     */
    void syncMissingTasks();
}

