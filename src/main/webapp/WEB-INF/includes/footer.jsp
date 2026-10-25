<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"
language="java" %> <%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="maple-footer-wrap" role="contentinfo">
  <div class="maple-footer-container">
    <div style="text-align: center" class="text-md-start">
      <a
        href="${pageContext.request.contextPath}/index.jsp"
        class="maple-footer-brand"
      >
        Maple &amp; Crumb
      </a>
      <p class="maple-footer-sub">
        &copy; 2026 Maple &amp; Crumb. All rights reserved. Handcrafted with
        heirloom techniques.
      </p>
    </div>

    <div class="maple-footer-links">
      <a
        class="maple-footer-link"
        href="${pageContext.request.contextPath}/menu"
        >Menu</a
      >
      <a
        class="maple-footer-link"
        href="${pageContext.request.contextPath}/bookCake"
        >Custom Cakes</a
      >
      <a class="maple-footer-link" href="mailto:hello@mapleandcrumb.lk"
        >Contact</a
      >
    </div>

    <div class="maple-footer-socials">
      <a
        aria-label="Follow Maple and Crumb on Instagram"
        class="maple-footer-social-link"
        href="#"
        >Instagram</a
      >
      <span class="maple-footer-dot">•</span>
      <a
        aria-label="Explore bespoke cakes on Pinterest"
        class="maple-footer-social-link"
        href="#"
        >Pinterest</a
      >
      <span class="maple-footer-dot">•</span>
      <a
        aria-label="Connect on Facebook"
        class="maple-footer-social-link"
        href="#"
        >Facebook</a
      >
    </div>
  </div>
</footer>

<!-- Global Toast Host Container -->
<div
  class="toast-container position-fixed bottom-0 end-0 p-3"
  style="z-index: 1090"
  id="globalToastContainer"
></div>

<!-- Bootstrap 5 Bundle JS (preserved for pages utilizing Bootstrap components) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- Maple & Crumb Shared JS -->
<script src="${pageContext.request.contextPath}/js/maple-crumb.js?v=2.1"></script>
