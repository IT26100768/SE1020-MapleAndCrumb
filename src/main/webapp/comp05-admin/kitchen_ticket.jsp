<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html class="h-full" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Make-Line Kitchen Ticket #${not empty task ? task.referenceCode : 'N/A'} — Maple &amp; Crumb</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&family=JetBrains+Mono:wght@700;800&display=swap" rel="stylesheet">
    <!-- Google Material Symbols Outlined -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Tailwind CSS (Play CDN) -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "primary": "#070100",
                        "primary-container": "#2b1810",
                        "surface": "#fdf9f1",
                        "surface-bright": "#fdf9f1",
                        "surface-container": "#f1ede6",
                        "surface-container-high": "#ece8e0",
                        "surface-container-highest": "#e6e2da",
                        "surface-container-lowest": "#ffffff",
                        "surface-variant": "#e6e2da",
                        "on-surface": "#1c1c17",
                        "on-surface-variant": "#4f4440",
                        "outline": "#817470",
                        "outline-variant": "#d3c3be",
                        "secondary": "#865225",
                        "secondary-fixed": "#ffdcc3",
                        "secondary-fixed-dim": "#fdb882",
                        "error": "#ba1a1a",
                        "error-container": "#ffdad6",
                        "on-error": "#ffffff",
                        "on-error-container": "#93000a"
                    },
                    fontFamily: {
                        "headline-lg": ["Playfair Display", "Georgia", "serif"],
                        "headline-md": ["Playfair Display", "Georgia", "serif"],
                        "headline-sm": ["Playfair Display", "Georgia", "serif"],
                        "body-lg": ["Outfit", "sans-serif"],
                        "body-md": ["Outfit", "sans-serif"],
                        "body-sm": ["Outfit", "sans-serif"],
                        "label-lg": ["Outfit", "sans-serif"],
                        "label-md": ["Outfit", "sans-serif"],
                        "label-sm": ["Outfit", "sans-serif"],
                        "mono-ticket": ["JetBrains Mono", "Courier New", "monospace"]
                    }
                }
            }
        }
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 500, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }
        .font-mono-ticket {
            font-family: 'JetBrains Mono', 'Courier New', monospace;
        }
        .font-headline-md, .font-headline-sm {
            font-family: 'Playfair Display', Georgia, serif;
        }
        .font-body-md, .font-label-md {
            font-family: 'Outfit', -apple-system, sans-serif;
        }
        @media print {
            body {
                background: #ffffff !important;
                padding: 0 !important;
                margin: 0 !important;
                -webkit-print-color-adjust: exact !important;
                print-color-adjust: exact !important;
            }
            .no-print {
                display: none !important;
            }
            .ticket-shadow {
                box-shadow: none !important;
                border: 2px solid #000000 !important;
            }
            main {
                max-width: 100% !important;
                width: 100% !important;
                margin: 0 !important;
                page-break-inside: avoid !important;
                break-inside: avoid !important;
            }
        }
    </style>
</head>
<body class="bg-[#f1ede6] font-body-md text-[#1c1c17] min-h-screen flex flex-col justify-start items-center p-3 sm:p-6 antialiased selection:bg-[#ffdcc3]">

<c:choose>
    <c:when test="${not empty task}">
        <!-- Kitchen Bar Utility Strip (Omit in Print) -->
        <header class="no-print w-full max-w-[620px] mb-3 flex items-center justify-between px-1">
            <div class="flex items-center gap-3">
                <a href="${pageContext.request.contextPath}/kitchenQueue" class="inline-flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold text-[#1c1c17] bg-white border border-[#817470]/40 rounded-full hover:bg-[#ece8e0] active:scale-[0.98] transition-all duration-150 shadow-sm text-decoration-none">
                    <span class="material-symbols-outlined text-sm">arrow_back</span>
                    <span>Back to Queue</span>
                </a>
                <span class="font-label-md font-bold tracking-widest text-[#4f4440] uppercase text-xs">KITCHEN TICKET</span>
            </div>
            <div class="flex items-center gap-2">
                <span class="hidden sm:inline text-[11px] font-mono font-bold tracking-wider text-[#4f4440] uppercase bg-white/70 px-2.5 py-1 rounded border border-[#817470]/20">
                    Station 01
                </span>
                <button type="button" class="flex items-center justify-center p-2.5 bg-[#070100] text-white rounded-full hover:bg-[#865225] active:scale-[0.98] transition-all duration-150 shadow-sm cursor-pointer" onclick="window.print()" title="Print Slip" aria-label="Print Slip">
                    <span class="material-symbols-outlined text-xl">print</span>
                    <span class="sr-only">Print Slip</span>
                </button>
            </div>
        </header>

        <!-- Physical Make-Line Docket (Domino's / Pizza Hut High-Readability Form Factor) -->
        <main class="w-full max-w-[620px] bg-white rounded-none border-2 border-[#070100] ticket-shadow shadow-[0_12px_32px_-6px_rgba(43,24,16,0.14)] overflow-hidden text-[#070100]">

            <!-- Top Bar: Line Rail Brand Anchor & Channel Tags -->
            <div class="bg-[#ece8e0] px-4 py-2 border-b-2 border-[#070100] flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span class="font-headline-sm text-lg font-bold tracking-tight text-[#070100]">Maple &amp; Crumb</span>
                </div>
                <div class="flex items-center gap-1.5">
                    <span class="px-2 py-0.5 bg-[#070100] text-white font-label-md text-xs font-bold rounded-sm tracking-wider uppercase">
                        ${task.taskType == 'CUSTOM_CAKE' ? 'CUSTOM CAKE' : 'PASTRY BATCH'}
                    </span>
                    <span class="px-2 py-0.5 bg-white border border-[#070100] text-[#070100] font-label-md text-xs font-bold rounded-sm tracking-wider uppercase">
                        ${task.fulfillmentType}
                    </span>
                </div>
            </div>

            <!-- PRIORITY 1: Scannable Header (Legible from 5 Feet Away) -->
            <section class="p-4 sm:p-5 border-b-2 border-[#070100] bg-white">
                <div class="flex items-stretch justify-between gap-3">
                    <!-- Large Ticket ID -->
                    <div class="flex flex-col justify-center">
                        <span class="font-label-md text-xs font-bold tracking-widest text-[#4f4440] uppercase">ORDER ID:</span>
                        <div class="font-mono-ticket text-5xl sm:text-6xl font-extrabold tracking-tighter text-[#070100] leading-none mt-1">
                            #${task.referenceCode}
                        </div>
                    </div>

                    <!-- Target Due Box (Domino's Style Urgency Box) -->
                    <div class="flex flex-col items-end justify-between text-right">
                        <div class="px-3 py-1.5 rounded-sm border-2 border-[#070100] flex flex-col items-end text-[#070100] bg-white">
                            <div class="flex items-center gap-1">
                                <span class="material-symbols-outlined text-[13px] leading-none text-[#4f4440]">schedule</span>
                                <span class="text-[10px] uppercase tracking-wider font-bold text-[#4f4440] leading-tight">TARGET DUE</span>
                            </div>
                            <span class="font-mono-ticket text-lg sm:text-xl font-extrabold tracking-tight leading-none mt-0.5 text-[#070100]">
                                ${not empty task.formattedShortDueDatetime ? task.formattedShortDueDatetime : (not empty task.timeSlot ? task.timeSlot : 'Immediate')}
                            </span>
                        </div>
                        <div class="mt-2 text-[11px] font-mono font-semibold text-[#4f4440]">
                            TASK #${task.taskId}
                        </div>
                    </div>
                </div>

                <!-- Station Status Bar -->
                <div class="mt-3.5 pt-3 border-t border-dashed border-[#817470] flex items-center justify-between text-xs">
                    <div class="flex items-center gap-2">
                        <span class="px-2 py-0.5 rounded-sm font-bold text-[11px] uppercase tracking-wider ${task.prepStage == 'COMPLETED' ? 'bg-emerald-100 text-emerald-800 border border-emerald-300' : (task.prepStage == 'IN_PREPARATION' ? 'bg-amber-100 text-amber-900 border border-amber-300' : 'bg-stone-100 text-stone-800 border border-stone-300')}">
                            ${task.displayStage}
                        </span>
                        <c:if test="${task.priority == 'URGENT'}">
                            <span class="px-2 py-0.5 rounded-sm font-bold text-[11px] uppercase tracking-wider bg-rose-600 text-white">
                                URGENT
                            </span>
                        </c:if>
                        <c:if test="${task.priority == 'HIGH'}">
                            <span class="px-2 py-0.5 rounded-sm font-bold text-[11px] uppercase tracking-wider bg-rose-100 text-rose-800 border border-rose-300">
                                HIGH PRIORITY
                            </span>
                        </c:if>
                    </div>
                    <div class="flex items-center gap-1.5 text-[#4f4440] font-medium text-[11px]">
                        <span class="material-symbols-outlined text-sm text-[#865225]">person</span>
                        <span>Baker: <strong class="text-[#070100]">${task.assignedBakerName}</strong></span>
                    </div>
                </div>
            </section>

            <c:choose>
                <c:when test="${task.taskType == 'CUSTOM_CAKE'}">
                    <!-- PRIORITY 2: What to Prepare (High-Contrast Bold Spec Grid for Custom Cake) -->
                    <section class="p-4 sm:p-5 border-b-2 border-[#070100] bg-white">
                        <!-- Prominent Product Identifier -->
                        <div class="border-b-2 border-[#070100] pb-3 mb-4">
                            <div class="flex items-baseline gap-2">
                                <span class="font-mono-ticket text-3xl font-extrabold text-[#070100]">1x</span>
                                <h1 class="font-headline-md text-2xl sm:text-3xl font-bold text-[#070100] tracking-tight">
                                    ${task.customCakeSizeInches}&Prime; ${task.customCakeFlavor} Cake
                                </h1>
                            </div>
                            <div class="flex items-center gap-2 mt-1.5 text-[#4f4440] font-medium text-sm">
                                <span class="font-bold text-[#070100]">${task.customCakeSizeInches} Inches Diameter</span>
                                <span class="text-[#817470]">&bull;</span>
                                <span>${task.customCakeFlavor}</span>
                            </div>
                        </div>

                        <!-- Core Recipe & Construction Specs (Direct 2-Column Grid with Real Data) -->
                        <div class="bg-[#fdf9f1] border border-[#e6e2da] rounded-sm p-3.5 space-y-2.5 text-sm">
                            <div class="flex items-baseline justify-between border-b border-[#e6e2da] pb-2">
                                <span class="text-xs text-[#4f4440] font-semibold tracking-wider uppercase">Flavor Profile</span>
                                <span class="text-sm sm:text-base font-bold text-[#070100]">${task.customCakeFlavor}</span>
                            </div>
                            <div class="flex items-baseline justify-between border-b border-[#e6e2da] pb-2">
                                <span class="text-xs text-[#4f4440] font-semibold tracking-wider uppercase">Size / Diameter</span>
                                <span class="text-sm sm:text-base font-bold text-[#070100]">${task.customCakeSizeInches} Inches (${task.customCakeSizeInches >= 10 ? '12–16' : (task.customCakeSizeInches >= 8 ? '8–10' : '6–8')} Servings)</span>
                            </div>
                            <div class="flex items-baseline justify-between">
                                <span class="text-xs text-[#4f4440] font-semibold tracking-wider uppercase">Preparation Notes</span>
                                <span class="text-sm sm:text-base font-bold text-[#070100]">${not empty task.kitchenNotes ? task.kitchenNotes : 'Bespoke Celebration Cake'}</span>
                            </div>
                        </div>
                    </section>
                </c:when>

                <c:otherwise>
                    <!-- PRIORITY 2: Pastry Batch Multi-Item Checklist Grid -->
                    <section class="p-4 sm:p-5 border-b-2 border-[#070100] bg-white">
                        <div class="border-b-2 border-[#070100] pb-2 mb-3 flex items-center justify-between">
                            <span class="text-xs font-bold tracking-widest text-[#4f4440] uppercase">BATCH ITEMS TO PREPARE:</span>
                            <span class="text-xs font-mono font-bold text-[#070100]">${task.items.size()} Product(s)</span>
                        </div>
                        <div class="divide-y divide-[#e6e2da] border border-[#e6e2da] rounded-sm bg-[#fdf9f1]">
                            <c:forEach var="item" items="${task.items}">
                                <div class="p-3 flex items-center justify-between gap-3">
                                    <div class="flex items-center gap-3">
                                        <span class="font-mono-ticket text-2xl font-extrabold text-[#070100] min-w-[45px]">${item.quantity}x</span>
                                        <div>
                                            <h2 class="font-headline-sm text-base sm:text-lg font-bold text-[#070100] leading-tight">${item.productName}</h2>
                                            <span class="text-xs text-[#4f4440] font-mono">SKU: #${item.productId}</span>
                                        </div>
                                    </div>
                                    <span class="text-xs font-bold uppercase tracking-wider px-2 py-0.5 bg-white border border-[#070100] rounded-sm">READY FOR PACK</span>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </c:otherwise>
            </c:choose>

            <!-- PRIORITY 3: Special Inscription & Verified Allergen Hazard -->
            <section class="p-4 sm:p-5 space-y-4 bg-white border-b-2 border-[#070100]">
                <!-- Custom Cake Inscription Box (Clear display framing) -->
                <c:if test="${not empty task.customCakeMessage}">
                    <div class="border-2 border-[#070100] bg-[#fdf9f1] p-3.5 sm:p-4 rounded-sm">
                        <span class="font-label-md text-xs font-bold tracking-widest uppercase text-[#4f4440] block mb-1.5">
                            CUSTOM INSCRIPTION:
                        </span>
                        <div class="p-3 bg-white border border-[#070100]/40 rounded-sm text-center">
                            <p class="font-headline-sm text-lg sm:text-xl text-blue-900 font-bold tracking-tight italic select-all mb-0">
                                &ldquo;${task.customCakeMessage}&rdquo;
                            </p>
                        </div>
                    </div>
                </c:if>

                <!-- Kitchen Specific Preparation Notes for Order -->
                <c:if test="${not empty task.kitchenNotes && task.taskType == 'ORDER'}">
                    <div class="p-3 rounded-sm bg-[#fdf9f1] border border-[#e6e2da]">
                        <span class="text-[11px] font-bold tracking-wider uppercase text-[#4f4440] block mb-1">
                            PRODUCTION NOTES:
                        </span>
                        <p class="text-sm text-[#070100] mb-0 whitespace-pre-line font-medium">
                            ${task.kitchenNotes}
                        </p>
                    </div>
                </c:if>

                <!-- Verified Allergen Alert (High-Visibility Safety Banner) -->
                <c:if test="${task.containsNuts || (not empty task.kitchenNotes && (task.kitchenNotes.toLowerCase().contains('nut') || task.kitchenNotes.toLowerCase().contains('allergy')))}">
                    <div class="p-3 sm:p-3.5 rounded-sm border-2 border-red-600 bg-red-50 text-red-950 flex items-start gap-2.5">
                        <span class="material-symbols-outlined text-2xl text-red-600 flex-shrink-0">warning</span>
                        <div>
                            <span class="text-xs font-extrabold uppercase tracking-wider text-red-700 block">
                                ALLERGEN WARNING: CONTAINS ALLERGENS / NUTS
                            </span>
                            <p class="text-xs font-semibold text-red-900 mt-0.5 mb-0">
                                Workspace sanitation required. Use dedicated utensils and allergen-free workstations.
                            </p>
                        </div>
                    </div>
                </c:if>
            </section>

            <!-- Customer & Fulfillment Information -->
            <section class="p-3.5 sm:p-4 bg-[#fdf9f1] border-b border-dashed border-[#070100] text-xs">
                <div class="flex flex-wrap items-center justify-between gap-2">
                    <div class="flex items-center gap-2">
                        <div class="w-7 h-7 rounded-full bg-[#fdb882] text-[#2f1500] font-bold flex items-center justify-center text-xs">
                            <c:out value="${task.customerName.length() > 0 ? task.customerName.substring(0, 1).toUpperCase() : 'C'}" />
                        </div>
                        <div>
                            <span class="text-[10px] text-[#4f4440] font-bold uppercase tracking-wider block">Customer</span>
                            <span class="font-bold text-[#070100] text-sm">${not empty task.customerName ? task.customerName : 'Walk-in Patron'}</span>
                            <c:if test="${not empty task.customerPhone}">
                                <span class="text-[#4f4440] text-[11px] ml-1">(${task.customerPhone})</span>
                            </c:if>
                        </div>
                    </div>
                    <div class="text-right">
                        <span class="text-[10px] text-[#4f4440] font-bold uppercase tracking-wider block">Fulfillment</span>
                        <span class="font-bold text-[#070100] uppercase">${task.fulfillmentType}</span>
                    </div>
                </div>
                <c:if test="${task.fulfillmentType == 'Delivery' && not empty task.deliveryAddress}">
                    <div class="mt-2 pt-2 border-t border-[#e6e2da] text-[#4f4440] flex items-center gap-1.5">
                        <span class="material-symbols-outlined text-sm text-[#070100]">location_on</span>
                        <span>Delivery Address: <strong class="text-[#070100]">${task.deliveryAddress}</strong></span>
                    </div>
                </c:if>
            </section>

            <!-- Slip Footer: Perforation Anchor / Clean Tear Line -->
            <div class="bg-[#ece8e0] px-4 py-2 flex items-center font-mono text-xs text-[#4f4440] justify-center">
                <span class="tracking-wide">
                    GENERATED AT <c:set var="ticketNow" value="<%= new java.util.Date() %>" /><fmt:formatDate value="${ticketNow}" pattern="hh:mm a • yyyy-MM-dd"/>
                </span>
            </div>
        </main>
    </c:when>

    <c:otherwise>
        <!-- Task Not Found Empty / Error State -->
        <div class="w-full max-w-[500px] mx-auto my-12 text-center p-8 bg-white border-2 border-[#070100] shadow-sm">
            <div class="inline-flex items-center justify-center mx-auto mb-4 w-14 h-14 rounded-full bg-red-100 text-red-600">
                <span class="material-symbols-outlined text-3xl">receipt_long</span>
            </div>
            <h2 class="font-headline-md text-2xl font-bold text-[#070100] mb-2">Kitchen Ticket Not Found</h2>
            <p class="text-sm text-[#4f4440] mb-6">The requested production ticket could not be located or may have been completed or removed.</p>
            <a href="${pageContext.request.contextPath}/kitchenQueue" class="inline-flex items-center justify-center gap-2 px-5 py-2.5 bg-[#070100] text-white font-bold text-xs uppercase tracking-wider rounded-sm hover:bg-[#865225] transition-all">
                <span class="material-symbols-outlined text-sm">arrow_back</span>
                <span>Return to Kitchen Queue</span>
            </a>
        </div>
    </c:otherwise>
</c:choose>

<script>
    // Micro-interaction for keyboard shortcuts (Cmd+P / Ctrl+P triggers print)
    document.addEventListener('keydown', function(event) {
        if ((event.metaKey || event.ctrlKey) && event.key === 'p') {
            // Native browser print will execute
        }
    });
</script>
</body>
</html>
