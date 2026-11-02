(function (window, document) {
  "use strict";

  // 1. Checkout State & Helpers (MapleCheckout)
  let checkoutBaseSubtotal = 0.0;
  let checkoutDeliveryFee = 0.0;

  function selectOrderType(type) {
    const deliveryRadio = document.getElementById("orderTypeDelivery");
    const pickupRadio = document.getElementById("orderTypePickup");
    if (type === "Delivery") {
      if (deliveryRadio) deliveryRadio.checked = true;
      if (pickupRadio) pickupRadio.checked = false;
    } else {
      if (pickupRadio) pickupRadio.checked = true;
      if (deliveryRadio) deliveryRadio.checked = false;
    }
    updateFulfillment();
  }

  function updateFulfillment() {
    const deliveryRadio = document.getElementById("orderTypeDelivery");
    const pickupRadio = document.getElementById("orderTypePickup");
    const isDelivery = deliveryRadio ? deliveryRadio.checked : false;
    const addrSection = document.getElementById("deliveryAddressSection");
    const addrInput = document.getElementById("deliveryAddressInput");
    const feeEl = document.getElementById("displayDeliveryFee");
    const totalEl = document.getElementById("displayGrandTotal");
    const pickupWrap = document.getElementById("pickupOptionWrapper");
    const deliveryWrap = document.getElementById("deliveryOptionWrapper");
    const pickupBadge = document.getElementById("pickupSelectedBadge");
    const deliveryBadge = document.getElementById("deliverySelectedBadge");

    if (isDelivery) {
      checkoutDeliveryFee = 500.0;
      if (deliveryRadio) deliveryRadio.checked = true;
      if (pickupRadio) pickupRadio.checked = false;
      if (deliveryWrap) deliveryWrap.classList.add("active");
      if (pickupWrap) pickupWrap.classList.remove("active");
      if (deliveryBadge) {
        deliveryBadge.classList.remove("d-none");
        deliveryBadge.style.display = "inline-block";
      }
      if (pickupBadge) {
        pickupBadge.classList.add("d-none");
        pickupBadge.style.display = "none";
      }
      if (addrSection) addrSection.classList.remove("d-none");
      if (addrInput) addrInput.required = true;
      if (feeEl) feeEl.textContent = "Rs. 500.00";
    } else {
      checkoutDeliveryFee = 0.0;
      if (pickupRadio) pickupRadio.checked = true;
      if (deliveryRadio) deliveryRadio.checked = false;
      if (pickupWrap) pickupWrap.classList.add("active");
      if (deliveryWrap) deliveryWrap.classList.remove("active");
      if (pickupBadge) {
        pickupBadge.classList.remove("d-none");
        pickupBadge.style.display = "inline-block";
      }
      if (deliveryBadge) {
        deliveryBadge.classList.add("d-none");
        deliveryBadge.style.display = "none";
      }
      if (addrSection) addrSection.classList.add("d-none");
      if (addrInput) addrInput.required = false;
      if (feeEl) feeEl.textContent = "Rs. 0.00";
    }

    if (totalEl) {
      const grandTotal = Number(
        checkoutBaseSubtotal + checkoutDeliveryFee,
      ).toLocaleString("en-US", {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
      });
      totalEl.textContent = "Rs. " + grandTotal;
    }
  }

  function selectPaymentMethod(method) {
    const methodInput = document.getElementById("paymentMethodInput");
    if (methodInput) methodInput.value = method;

    document.querySelectorAll(".payment-method-card").forEach(function (c) {
      c.classList.remove("active");
    });

    const cardFields = document.getElementById("cardPaymentFields");
    const counterFields = document.getElementById("counterCashFields");

    if (cardFields) cardFields.classList.add("d-none");
    if (counterFields) counterFields.classList.add("d-none");

    if (method === "CARD_SIMULATED") {
      const el = document.getElementById("payMethodCard");
      if (el) el.classList.add("active");
      if (cardFields) cardFields.classList.remove("d-none");
    } else if (method === "COUNTER_CASH") {
      const el = document.getElementById("payMethodCounter");
      if (el) el.classList.add("active");
      if (counterFields) counterFields.classList.remove("d-none");
    }
  }

  function formatCardNumber(input) {
    let v = input.value.replace(/\s+/g, "").replace(/[^0-9]/gi, "");
    let matches = v.match(/\d{4,16}/g);
    let match = (matches && matches[0]) || "";
    let parts = [];
    for (let i = 0, len = match.length; i < len; i += 4) {
      parts.push(match.substring(i, i + 4));
    }
    if (parts.length) {
      input.value = parts.join(" ");
    }
  }

  function handleFormSubmit(e) {
    const form = document.getElementById("checkoutForm");
    if (form && !form.checkValidity()) {
      e.preventDefault();
      e.stopPropagation();
      form.classList.add("was-validated");
      return false;
    }
    const btn = document.getElementById("btnPlaceOrder");
    if (btn) {
      btn.disabled = true;
      btn.innerHTML =
        '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> Processing Simulated Payment...';
    }
    return true;
  }

  const MapleCheckout = {
    init: function (baseSubtotal) {
      checkoutBaseSubtotal = parseFloat(baseSubtotal) || 0.0;

      const checkoutOrderTypeRadios = document.querySelectorAll(
        'input[name="orderType"]',
      );
      checkoutOrderTypeRadios.forEach(function (radio) {
        if (!radio.dataset.checkoutRadioInit) {
          radio.dataset.checkoutRadioInit = "true";
          radio.addEventListener("change", function () {
            updateFulfillment();
          });
        }
      });
      updateFulfillment();
    },
  };

  // 2. Order History Cards Filter (order_history.jsp)
  let orderActiveFilter = "ALL";
  const PROCESSING_STATUSES = [
    "processing",
    "confirmed",
    "baking",
    "in preparation",
    "out for delivery",
  ];
  const COMPLETED_STATUSES = ["completed", "finished"];

  function setOrderStatusFilter(status, btn) {
    orderActiveFilter = status;
    try {
      sessionStorage.setItem("orderActiveStatus", status);
      const url = new URL(window.location.href);
      if (status && status !== "ALL") {
        url.searchParams.set("status", status);
      } else {
        url.searchParams.delete("status");
      }
      window.history.replaceState({}, "", url.toString());
    } catch (e) {}

    const filterGroup = btn
      ? btn.closest('[role="group"]')
      : document.querySelector('[aria-label="Filter Orders by Status"]');
    const buttons = filterGroup
      ? filterGroup.querySelectorAll(".btn")
      : document.querySelectorAll(
          '[aria-label="Filter Orders by Status"] .btn',
        );
    buttons.forEach(function (b) {
      b.classList.remove("btn-maple-primary", "active");
      b.classList.add("btn-maple-secondary");
      b.setAttribute("aria-pressed", "false");
    });
    if (btn) {
      btn.classList.remove("btn-maple-secondary");
      btn.classList.add("btn-maple-primary", "active");
      btn.setAttribute("aria-pressed", "true");
    }
    filterOrders();
  }

  function filterOrders() {
    const query = (document.getElementById("orderSearchInput")?.value || "")
      .toLowerCase()
      .trim();
    const items = document.querySelectorAll(".order-card-item");
    let visibleCount = 0;

    items.forEach(function (item) {
      const text = item.innerText.toLowerCase();
      const status = (item.getAttribute("data-status") || "").toLowerCase();
      const matchesQuery = !query || text.includes(query);
      let matchesStatus = false;

      if (orderActiveFilter === "ALL") {
        matchesStatus = true;
      } else if (orderActiveFilter === "Processing") {
        matchesStatus = PROCESSING_STATUSES.includes(status);
      } else if (orderActiveFilter === "Completed") {
        matchesStatus = COMPLETED_STATUSES.includes(status);
      } else {
        matchesStatus = status === orderActiveFilter.toLowerCase();
      }

      if (matchesQuery && matchesStatus) {
        item.style.display = "";
        visibleCount++;
      } else {
        item.style.display = "none";
      }
    });

    const noOrdersCard = document.getElementById("clientSideNoOrders");
    if (noOrdersCard) {
      noOrdersCard.classList.toggle(
        "d-none",
        visibleCount > 0 || items.length === 0,
      );
    }
  }

  function resetOrderFilters() {
    const searchInput = document.getElementById("orderSearchInput");
    if (searchInput) searchInput.value = "";
    const allBtn = document.getElementById("orderFilterAll");
    setOrderStatusFilter("ALL", allBtn);
  }

  function initOrderHistoryFilters() {
    try {
      const urlParams = new URLSearchParams(window.location.search);
      const statusParam =
        urlParams.get("status") || sessionStorage.getItem("orderActiveStatus");
      if (statusParam && statusParam !== "ALL") {
        const btnIdMap = {
          pending: "orderFilterPending",
          processing: "orderFilterProcessing",
          completed: "orderFilterCompleted",
          cancelled: "orderFilterCancelled",
        };
        const btnId = btnIdMap[statusParam.toLowerCase()];
        const targetBtn = btnId ? document.getElementById(btnId) : null;
        if (targetBtn) {
          setOrderStatusFilter(statusParam, targetBtn);
          return;
        }
      }
    } catch (e) {}
    filterOrders();
  }

  window.MapleCheckout = MapleCheckout;
  window.selectOrderType = selectOrderType;
  window.updateFulfillment = updateFulfillment;
  window.selectPaymentMethod = selectPaymentMethod;
  window.formatCardNumber = formatCardNumber;
  window.handleFormSubmit = handleFormSubmit;
  window.setOrderStatusFilter = setOrderStatusFilter;
  window.filterOrders = filterOrders;
  window.resetOrderFilters = resetOrderFilters;
  window.initOrderHistoryFilters = initOrderHistoryFilters;
})(window, document);
