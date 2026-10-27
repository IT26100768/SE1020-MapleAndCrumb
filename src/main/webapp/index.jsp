<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Maple &amp; Crumb | Artisanal Pâtisserie &amp; Bespoke Cakes</title>
    <meta name="description"
          content="Discover freshly baked Viennoiserie favourites and create your perfect custom celebration cake for every special occasion, handcrafted with heirloom techniques in Colombo.">

    <!-- Google Fonts: Playfair Display & Outfit -->
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&amp;family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400;1,600&amp;display=swap"
          rel="stylesheet">

    <!-- Material Symbols Outlined -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
          rel="stylesheet">

    <!-- Maple & Crumb Custom Styling -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/maple-crumb.css">

    <!-- Tailwind CSS v3 CDN -->
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>

    <!-- Tailwind Theme Configuration Verbatim from Stitch -->
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "error-container": "#ffdad6",
                        "primary-container": "#2b1810",
                        "on-primary-fixed": "#2a170f",
                        "on-secondary-fixed": "#2f1500",
                        "on-tertiary-container": "#a17f3c",
                        "on-error-container": "#93000a",
                        "tertiary-fixed": "#ffdea5",
                        "outline-variant": "#d3c3be",
                        "background": "#fdf9f1",
                        "surface-container-high": "#ece8e0",
                        "surface": "#fdf9f1",
                        "primary-fixed-dim": "#e2bfb2",
                        "on-primary": "#ffffff",
                        "secondary-container": "#fdb882",
                        "surface-tint": "#73584e",
                        "primary-fixed": "#ffdbcd",
                        "surface-variant": "#e6e2da",
                        "inverse-primary": "#e2bfb2",
                        "outline": "#817470",
                        "surface-dim": "#dddad2",
                        "on-tertiary": "#ffffff",
                        "on-secondary-container": "#78471b",
                        "inverse-on-surface": "#f4f0e8",
                        "secondary": "#865225",
                        "on-primary-container": "#9c7e73",
                        "on-secondary-fixed-variant": "#6a3b10",
                        "on-surface-variant": "#4f4440",
                        "on-primary-fixed-variant": "#5a4137",
                        "on-tertiary-fixed": "#261900",
                        "surface-container-low": "#f7f3eb",
                        "inverse-surface": "#31302b",
                        "surface-bright": "#fdf9f1",
                        "tertiary-container": "#281a00",
                        "tertiary": "#030200",
                        "primary": "#070100",
                        "on-error": "#ffffff",
                        "surface-container-lowest": "#ffffff",
                        "on-tertiary-fixed-variant": "#5d4201",
                        "on-surface": "#1c1c17",
                        "tertiary-fixed-dim": "#e9c176",
                        "on-secondary": "#ffffff",
                        "on-background": "#1c1c17",
                        "error": "#ba1a1a",
                        "surface-container": "#f1ede6",
                        "secondary-fixed": "#ffdcc3",
                        "surface-container-highest": "#e6e2da",
                        "secondary-fixed-dim": "#fdb882"
                    },
                    "borderRadius": {
                        "DEFAULT": "1rem",
                        "lg": "2rem",
                        "xl": "3rem",
                        "full": "9999px"
                    },
                    "spacing": {
                        "space-lg": "1.5rem",
                        "margin-mobile": "1.25rem",
                        "space-xs": "0.25rem",
                        "gutter": "2rem",
                        "space-xl": "2.5rem",
                        "space-md": "1rem",
                        "gutter-mobile": "1rem",
                        "margin": "4rem",
                        "space-sm": "0.5rem"
                    },
                    "fontFamily": {
                        "body-lg": ["Outfit", "sans-serif"],
                        "body-sm": ["Outfit", "sans-serif"],
                        "headline-lg-mobile": ["Playfair Display", "serif"],
                        "display-lg-mobile": ["Playfair Display", "serif"],
                        "body-md": ["Outfit", "sans-serif"],
                        "headline-md": ["Playfair Display", "serif"],
                        "display-lg": ["Playfair Display", "serif"],
                        "label-lg": ["Outfit", "sans-serif"],
                        "headline-lg": ["Playfair Display", "serif"],
                        "headline-sm": ["Playfair Display", "serif"],
                        "label-sm": ["Outfit", "sans-serif"],
                        "label-md": ["Outfit", "sans-serif"]
                    },
                    "fontSize": {
                        "body-lg": ["18px", {"lineHeight": "28px", "letterSpacing": "0.01em", "fontWeight": "400"}],
                        "body-sm": ["13px", {"lineHeight": "20px", "letterSpacing": "0.01em", "fontWeight": "400"}],
                        "headline-lg-mobile": ["28px", {
                            "lineHeight": "36px",
                            "letterSpacing": "0em",
                            "fontWeight": "500"
                        }],
                        "display-lg-mobile": ["36px", {
                            "lineHeight": "44px",
                            "letterSpacing": "-0.01em",
                            "fontWeight": "600"
                        }],
                        "body-md": ["15px", {"lineHeight": "24px", "letterSpacing": "0.01em", "fontWeight": "400"}],
                        "headline-md": ["28px", {"lineHeight": "36px", "letterSpacing": "0em", "fontWeight": "500"}],
                        "display-lg": ["56px", {"lineHeight": "64px", "letterSpacing": "-0.02em", "fontWeight": "600"}],
                        "label-lg": ["14px", {"lineHeight": "20px", "letterSpacing": "0.04em", "fontWeight": "600"}],
                        "headline-lg": ["40px", {
                            "lineHeight": "48px",
                            "letterSpacing": "-0.01em",
                            "fontWeight": "500"
                        }],
                        "headline-sm": ["22px", {"lineHeight": "30px", "letterSpacing": "0em", "fontWeight": "600"}],
                        "label-sm": ["11px", {"lineHeight": "14px", "letterSpacing": "0.08em", "fontWeight": "500"}],
                        "label-md": ["12px", {"lineHeight": "16px", "letterSpacing": "0.06em", "fontWeight": "600"}]
                    }
                }
            }
        }
    </script>

</head>
<body class="bg-background text-on-surface antialiased selection:bg-secondary-fixed selection:text-on-secondary-fixed min-h-screen flex flex-col font-body-md text-body-md">

<!-- ================= TOP NAVIGATION BAR INCLUSION ================= -->
<jsp:include page="/WEB-INF/includes/navbar.jsp"/>

<main class="flex-grow">
    <!-- ================= HERO SECTION ================= -->
    <section class="max-w-[1440px] mx-auto px-6 sm:px-8 lg:px-12 pt-8 sm:pt-12 pb-16 sm:pb-20">
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16 items-center">
            <!-- Left Column: Editorial Copy & Callouts -->
            <div class="lg:col-span-6 flex flex-col justify-center pr-0 lg:pr-4">
                <!-- Status Pill -->
                <div class="inline-flex items-center gap-2 self-start bg-surface-container-low border border-outline-variant/40 px-3.5 py-1.5 rounded-full mb-6">
                    <span class="w-2 h-2 rounded-full bg-secondary animate-pulse"></span>
                    <span class="font-label-sm text-label-sm font-semibold tracking-wider text-on-surface-variant uppercase">
              Now Taking Seasonal Commissions
            </span>
                </div>

                <!-- Main Serif Headline -->
                <h1 class="font-display-lg text-display-lg text-primary tracking-tight leading-[1.08] mb-6">
                    Baked with Love.<br>
                    <span class="italic font-normal text-secondary">Made for Your Moments.</span>
                </h1>

                <!-- Supporting Editorial Text -->
                <p class="font-body-lg text-body-lg text-on-surface-variant max-w-xl mb-8 leading-relaxed">
                    Discover freshly baked Viennoiserie favourites and create your perfect custom celebration cake for
                    every special occasion, handcrafted with heirloom techniques in Colombo.
                </p>

                <!-- Primary & Secondary CTA Cluster -->
                <div class="flex flex-wrap items-center gap-4 mb-10">
                    <a class="bg-primary text-background font-label-lg text-label-lg px-8 py-3.5 rounded-full font-medium hover:bg-secondary hover:text-background active:scale-[0.98] transition-all flex items-center gap-2 shadow-md"
                       href="${pageContext.request.contextPath}/menu">
                        <span>Explore Our Menu</span>
                        <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                    </a>
                    <a class="border-2 border-secondary text-primary font-label-lg text-label-lg px-7 py-3.5 rounded-full font-medium hover:bg-surface-container-high hover:text-primary active:scale-[0.98] transition-all"
                       href="${pageContext.request.contextPath}/bookCake">
                        Create Your Cake
                    </a>
                </div>

                <!-- Trust Badges & Quality Indicators -->
                <div class="pt-6 border-t border-outline-variant/30 flex flex-wrap items-center gap-6">
                    <div class="flex items-center gap-2.5">
                        <span class="material-symbols-outlined text-secondary text-[22px]">auto_awesome</span>
                        <span class="font-label-md text-label-md font-semibold text-primary">Freshly Baked Daily</span>
                    </div>
                    <div class="w-1.5 h-1.5 rounded-full bg-outline-variant/60"></div>
                    <div class="flex items-center gap-2.5">
                        <span class="material-symbols-outlined text-secondary text-[22px]">verified</span>
                        <span class="font-label-md text-label-md font-semibold text-primary">100% Normandy Butter</span>
                    </div>
                    <div class="w-1.5 h-1.5 rounded-full bg-outline-variant/60"></div>
                    <div class="flex items-center gap-2.5">
                        <span class="material-symbols-outlined text-secondary text-[22px]">local_shipping</span>
                        <span class="font-label-md text-label-md font-semibold text-primary">Refrigerated Courier</span>
                    </div>
                </div>
            </div>

            <!-- Right Column: Hero Visual Showcase -->
            <div class="lg:col-span-6 relative">
                <div class="relative w-full aspect-[4/5] max-h-[640px] rounded-lg overflow-hidden shadow-luxury-hero border border-outline-variant/20 bg-surface-container-low group">
                    <img
                            alt="Three-tiered artisanal white buttercream wedding cake adorned with fresh figs, delicate purple edible blossoms, and blackberries on an antique brass marble pedestal"
                            class="w-full h-full object-cover object-center group-hover:scale-105 transition-transform duration-700 ease-out"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuBl2Sw8sGMYM-MVWSYIOY-TdVgHJDH-jUq_EO-YyVihQyF2pjoABe6EYOjmTROVCSnc5KpgG49C0iDxniB9z4nYL2dKCc_RTtOTWxWZhZhxOSYlN7KeBhrfomhbkivwFXYLGm2mEf2pgdGFcoPC3K0EwBGzE8xzG4ryh25XiP80-MwfhKS4gRozME8s_JOs7-mK93a5Su3czxAbtJ-LvTzLJbhsDRxlCo4SiMr8LDMBafDbRf8SNcBbQA"
                            onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1535141192574-5d4897c13136?auto=format&fit=crop&w=1000&q=85';"
                    >
                    <!-- Overlay Sheen -->
                    <div class="absolute inset-0 bg-gradient-to-t from-primary/50 via-transparent to-transparent pointer-events-none"></div>

                    <!-- Floating Pill Badge for Signature Cake -->
                    <div class="absolute bottom-6 left-6 right-6 sm:right-auto bg-surface-bright/95 backdrop-blur-md px-5 py-4 rounded-xl shadow-luxury-card border border-outline-variant/30 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-full bg-secondary-fixed/50 flex items-center justify-center text-secondary">
                            <span class="material-symbols-outlined text-[26px]">cake</span>
                        </div>
                        <div>
                            <p class="font-label-sm text-label-sm uppercase tracking-wider text-secondary font-semibold">
                                Maple &amp; Crumb Specialties</p>
                            <p class="font-headline-sm text-[18px] font-medium text-primary">Signature Pistachio &amp;
                                Fig</p>
                        </div>
                        <a aria-label="View Signature Pistachio and Fig custom cake"
                           class="ml-auto w-9 h-9 rounded-full bg-surface-container-high hover:bg-secondary hover:text-on-secondary flex items-center justify-center transition-colors"
                           href="${pageContext.request.contextPath}/bookCake">
                            <span class="material-symbols-outlined text-[18px]">north_east</span>
                        </a>
                    </div>
                </div>

                <!-- Decorative Accent Frame -->
                <div class="absolute -bottom-4 -right-4 w-48 h-48 border-2 border-secondary/20 rounded-lg -z-10 hidden sm:block"></div>
            </div>
        </div>
    </section>

    <!-- ================= BEST SELLERS ================= -->
    <section class="max-w-[1440px] mx-auto px-6 sm:px-8 lg:px-12 py-20 sm:py-24" id="shop">
        <!-- Section Heading & Filter Tabs -->
        <div class="flex flex-col md:flex-row md:items-end justify-between mb-8 gap-4">
            <div>
          <span class="font-label-sm text-label-sm uppercase tracking-widest text-secondary font-semibold mb-2 block">
            Most Adored by Colombo
          </span>
                <h2 class="font-headline-lg text-headline-lg text-primary tracking-tight">
                    Our Signature Best Sellers
                </h2>
            </div>
            <a class="inline-flex items-center gap-2 font-label-lg text-label-lg text-primary font-medium hover:text-secondary group transition-colors"
               href="${pageContext.request.contextPath}/menu">
                <span>View All Confections</span>
                <span class="material-symbols-outlined text-[18px] group-hover:translate-x-1 transition-transform">trending_flat</span>
            </a>
        </div>

        <!-- Filter Tabs -->
        <div class="flex items-center gap-2 flex-wrap mb-10" role="tablist"
             aria-label="Filter signature bakery collection">
            <button type="button" onclick="filterBestSellers('all', this)"
                    class="filter-btn active bg-primary text-background px-4 py-2 rounded-full font-label-md text-label-md font-semibold transition-all">
                All Creations
            </button>
            <button type="button" onclick="filterBestSellers('cakes', this)"
                    class="filter-btn bg-surface-container-high text-on-surface-variant hover:text-primary px-4 py-2 rounded-full font-label-md text-label-md font-semibold transition-all">
                Celebration Cakes
            </button>
            <button type="button" onclick="filterBestSellers('pastries', this)"
                    class="filter-btn bg-surface-container-high text-on-surface-variant hover:text-primary px-4 py-2 rounded-full font-label-md text-label-md font-semibold transition-all">
                Pastries &amp; Breads
            </button>
        </div>

        <!-- 4-Product Grid with LKR (Rs.) Pricing -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8" id="productGrid">
            <!-- Product 1: The Gilded Fleur Entremet -->
            <article data-cat="cakes"
                     class="product-item bg-surface-container-lowest rounded-DEFAULT border border-outline-variant/30 overflow-hidden shadow-luxury-card hover:shadow-luxury-hover hover:border-secondary transition-all flex flex-col group">
                <div class="relative w-full aspect-[4/3] overflow-hidden bg-surface-container">
                    <img
                            alt="The Gilded Fleur Entremet wedding and celebration cake"
                            class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500 ease-out"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuBl2Sw8sGMYM-MVWSYIOY-TdVgHJDH-jUq_EO-YyVihQyF2pjoABe6EYOjmTROVCSnc5KpgG49C0iDxniB9z4nYL2dKCc_RTtOTWxWZhZhxOSYlN7KeBhrfomhbkivwFXYLGm2mEf2pgdGFcoPC3K0EwBGzE8xzG4ryh25XiP80-MwfhKS4gRozME8s_JOs7-mK93a5Su3czxAbtJ-LvTzLJbhsDRxlCo4SiMr8LDMBafDbRf8SNcBbQA"
                            onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=600&q=80';"
                    >
                </div>
                <div class="p-6 flex flex-col flex-grow">
                    <!-- Title -->
                    <h3 class="font-headline-sm text-[20px] font-semibold text-primary mb-1">
                        The Gilded Fleur Entremet
                    </h3>
                    <p class="font-body-sm text-body-sm text-on-surface-variant mb-4 flex-grow line-clamp-2">
                        Layered pistachio sponge, organic fig compote, and whipped vanilla mascarpone.
                    </p>
                    <!-- Price and Action -->
                    <div class="pt-4 border-t border-outline-variant/20 flex items-center justify-between">
                        <div>
                            <p class="font-label-sm text-label-sm text-on-surface-variant">Starting from</p>
                            <p class="font-headline-sm text-[20px] font-bold text-primary">Rs. 4,800</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/menu"
                           class="bg-primary text-background font-label-md text-label-md px-4 py-2.5 rounded-full font-medium hover:bg-secondary hover:text-background active:scale-[0.96] transition-all flex items-center gap-1.5 shadow-sm">
                            <span class="material-symbols-outlined text-[16px]">add_shopping_cart</span>
                            <span>Add to Cart</span>
                        </a>
                    </div>
                </div>
            </article>

            <!-- Product 2: Pain au Chocolat & Danish Duo -->
            <article data-cat="pastries"
                     class="product-item bg-surface-container-lowest rounded-DEFAULT border border-outline-variant/30 overflow-hidden shadow-luxury-card hover:shadow-luxury-hover hover:border-secondary transition-all flex flex-col group">
                <div class="relative w-full aspect-[4/3] overflow-hidden bg-surface-container">
                    <img
                            alt="Artisanal Pain au Chocolat &amp; Danish Duo"
                            class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500 ease-out"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuCFaKS2FKGZiKQa7E6CsleGU_sezOlGIykG0dvXUscugjlynHXv7E1TJqiP-wDZ9T0XDNg9Ue_YpdwLwXdlEeQ2TLRALdhyL5nxYXO-2YdnqL0cRXJAl4WxfTIRCgh8nobnzcV8lqydb2o9e1to1oUcha3433BxW6PtReDm-Cxicw8tYyuSX9wo6nwDSxVECpXaNc4nFBjVU7SAJEHLjX_ST2KHpyeaOBFPO8KS99NVhuUT_nWio-M4xg"
                            onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=600&q=80';"
                    >
                </div>
                <div class="p-6 flex flex-col flex-grow">
                    <!-- Title -->
                    <h3 class="font-headline-sm text-[20px] font-semibold text-primary mb-1">
                        Pain au Chocolat &amp; Danish Duo
                    </h3>
                    <p class="font-body-sm text-body-sm text-on-surface-variant mb-4 flex-grow line-clamp-2">
                        72-layer laminated pastry, Valrhona 70% dark batons, and glazed apricot preserve.
                    </p>
                    <!-- Price and Action -->
                    <div class="pt-4 border-t border-outline-variant/20 flex items-center justify-between">
                        <div>
                            <p class="font-label-sm text-label-sm text-on-surface-variant">Duo Box</p>
                            <p class="font-headline-sm text-[20px] font-bold text-primary">Rs. 1,650</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/menu"
                           class="bg-primary text-background font-label-md text-label-md px-4 py-2.5 rounded-full font-medium hover:bg-secondary hover:text-background active:scale-[0.96] transition-all flex items-center gap-1.5 shadow-sm">
                            <span class="material-symbols-outlined text-[16px]">add_shopping_cart</span>
                            <span>Add to Cart</span>
                        </a>
                    </div>
                </div>
            </article>

            <!-- Product 3: Country Sourdough Loaf -->
            <article data-cat="pastries"
                     class="product-item bg-surface-container-lowest rounded-DEFAULT border border-outline-variant/30 overflow-hidden shadow-luxury-card hover:shadow-luxury-hover hover:border-secondary transition-all flex flex-col group">
                <div class="relative w-full aspect-[4/3] overflow-hidden bg-surface-container">
                    <img
                            alt="Slow-Fermented Country Sourdough Loaf"
                            class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500 ease-out"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuCBUcm2xO6sLRREUqvsg3APr4x3OYdAGYxO4DtU9QzWluojTmaCXPsQtQLPMFgJoqznPR2RVmdE5-zu6AKHv23VkMW6kuMqN3n92sfXJMURdQlRZro7rktVjLtzqxrsSrP5EVtDSNvh4UlI-G3-5UL6azLeH5CZtmiwyoOzJ47y8haL6YhRxaSaI8X96e0Khw1QxSpGRvydE5O_Ga_AugyDm4jwwlNujPeF8EcfMtz4Un1sttcCrSda1g"
                            onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80';"
                    >
                </div>
                <div class="p-6 flex flex-col flex-grow">
                    <!-- Title -->
                    <h3 class="font-headline-sm text-[20px] font-semibold text-primary mb-1">
                        Country Sourdough Loaf
                    </h3>
                    <p class="font-body-sm text-body-sm text-on-surface-variant mb-4 flex-grow line-clamp-2">
                        36-hour cold ferment, stoneground wheat, blistering caramelized blister crust.
                    </p>
                    <!-- Price and Action -->
                    <div class="pt-4 border-t border-outline-variant/20 flex items-center justify-between">
                        <div>
                            <p class="font-label-sm text-label-sm text-on-surface-variant">Whole Boule (850g)</p>
                            <p class="font-headline-sm text-[20px] font-bold text-primary">Rs. 1,200</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/menu"
                           class="bg-primary text-background font-label-md text-label-md px-4 py-2.5 rounded-full font-medium hover:bg-secondary hover:text-background active:scale-[0.96] transition-all flex items-center gap-1.5 shadow-sm">
                            <span class="material-symbols-outlined text-[16px]">add_shopping_cart</span>
                            <span>Add to Cart</span>
                        </a>
                    </div>
                </div>
            </article>

            <!-- Product 4: Vanilla & Berry Rosette Cake -->
            <article data-cat="cakes"
                     class="product-item bg-surface-container-lowest rounded-DEFAULT border border-outline-variant/30 overflow-hidden shadow-luxury-card hover:shadow-luxury-hover hover:border-secondary transition-all flex flex-col group">
                <div class="relative w-full aspect-[4/3] overflow-hidden bg-surface-container">
                    <img
                            alt="Tahitian Vanilla &amp; Berry Rosette Cake"
                            class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500 ease-out"
                            src="https://lh3.googleusercontent.com/aida-public/AB6AXuBKjJPMTCiggsv3RMPnFz-GUhr507VMH0JYkX2qv1LTBKapU1H3cVAeFbxHhGmHFPcEI2qevdqdOeOxjyYdqspx-_4a8FVkKgZ3I4Y7pFWBu0GH4Ak4_MUKGdK5d6Xbda0D7xyogexK_mHMMt-EuPHl3RJJDyYcSFRwBMjS32y5jOariuNDE-RMG1N8IM48Gqd-mLzFVuI_k1aTPCaaBoVLzjZ5KQzPa3nPP46LwiCxH1nYyDgUUnhvyQ"
                            onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1565958011703-44f9829ba187?auto=format&fit=crop&w=600&q=80';"
                    >
                </div>
                <div class="p-6 flex flex-col flex-grow">
                    <!-- Title -->
                    <h3 class="font-headline-sm text-[20px] font-semibold text-primary mb-1">
                        Vanilla &amp; Berry Rosette Cake
                    </h3>
                    <p class="font-body-sm text-body-sm text-on-surface-variant mb-4 flex-grow line-clamp-2">
                        Pure Tahitian bean butter cake layered with crushed summer berry coulis and rosette cream.
                    </p>
                    <!-- Price and Action -->
                    <div class="pt-4 border-t border-outline-variant/20 flex items-center justify-between">
                        <div>
                            <p class="font-label-sm text-label-sm text-on-surface-variant">6-inch (8 Servings)</p>
                            <p class="font-headline-sm text-[20px] font-bold text-primary">Rs. 6,500</p>
                        </div>
                        <a href="${pageContext.request.contextPath}/menu"
                           class="bg-primary text-background font-label-md text-label-md px-4 py-2.5 rounded-full font-medium hover:bg-secondary hover:text-background active:scale-[0.96] transition-all flex items-center gap-1.5 shadow-sm">
                            <span class="material-symbols-outlined text-[16px]">add_shopping_cart</span>
                            <span>Add to Cart</span>
                        </a>
                    </div>
                </div>
            </article>
        </div>
    </section>

    <!-- ================= CUSTOM CAKE BOOKING PROMOTION & ESTIMATOR ================= -->
    <section class="bg-surface-container-high/60 border-y border-outline-variant/30 py-20 sm:py-24" id="custom-cakes">
        <div class="max-w-[1440px] mx-auto px-6 sm:px-8 lg:px-12">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-12 lg:gap-16 items-center">
                <!-- Left Visual: Chef Decorating -->
                <div class="lg:col-span-6 relative order-2 lg:order-1">
                    <div class="relative w-full aspect-[4/3] rounded-lg overflow-hidden shadow-luxury-hero border border-outline-variant/30 bg-surface-container group">
                        <img
                                alt="Pastry chef decorating a multi-tier bespoke wedding cake with delicate piped rosette flowers"
                                class="w-full h-full object-cover object-center group-hover:scale-105 transition-transform duration-700 ease-out"
                                src="https://lh3.googleusercontent.com/aida-public/AB6AXuBKjJPMTCiggsv3RMPnFz-GUhr507VMH0JYkX2qv1LTBKapU1H3cVAeFbxHhGmHFPcEI2qevdqdOeOxjyYdqspx-_4a8FVkKgZ3I4Y7pFWBu0GH4Ak4_MUKGdK5d6Xbda0D7xyogexK_mHMMt-EuPHl3RJJDyYcSFRwBMjS32y5jOariuNDE-RMG1N8IM48Gqd-mLzFVuI_k1aTPCaaBoVLzjZ5KQzPa3nPP46LwiCxH1nYyDgUUnhvyQ"
                                onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1556910103-1c02745aae4d?auto=format&fit=crop&w=1000&q=80';"
                        >
                    </div>
                    <!-- Floating Consultation Card -->
                    <div class="absolute -bottom-6 -right-4 sm:right-6 bg-surface-bright p-5 rounded-DEFAULT shadow-luxury-hover border border-outline-variant/30 max-w-xs hidden sm:flex items-center gap-3">
                        <div class="w-10 h-10 rounded-full bg-secondary-fixed/50 flex items-center justify-center text-secondary flex-shrink-0">
                            <span class="material-symbols-outlined text-[20px]">palette</span>
                        </div>
                        <div>
                            <p class="font-label-sm text-label-sm uppercase font-semibold text-secondary">Custom Cake
                                Bookings</p>
                            <p class="font-headline-sm text-[16px] text-primary font-medium">Bespoke Flavor Pairings</p>
                        </div>
                    </div>
                </div>

                <!-- Right Content: Bespoke Booking Narrative & Checklist -->
                <div class="lg:col-span-6 order-1 lg:order-2">
            <span class="font-label-sm text-label-sm uppercase tracking-widest text-secondary font-semibold mb-2 block">
              Bespoke Culinary Commissions
            </span>
                    <h2 class="font-headline-lg text-headline-lg text-primary tracking-tight leading-tight mb-6">
                        A Cake as Unique as Your Celebration
                    </h2>
                    <p class="font-body-lg text-body-lg text-on-surface-variant mb-8 leading-relaxed">
                        Whether commemorating an intimate wedding, anniversary milestone, or grand gala, our master
                        pâtissiers craft tailored multi-tiered edible centerpieces designed strictly to your aesthetic
                        and palate.
                    </p>

                    <!-- Consultation Perks Checklist -->
                    <div class="space-y-4 mb-10">
                        <div class="flex items-start gap-3.5">
                            <div class="w-6 h-6 rounded-full bg-secondary-fixed/60 flex items-center justify-center text-secondary mt-0.5 flex-shrink-0">
                                <span class="material-symbols-outlined text-[16px]">check</span>
                            </div>
                            <div>
                                <h4 class="font-label-lg text-label-lg font-semibold text-primary">Personalized Tasting
                                    Box</h4>
                                <p class="font-body-sm text-body-sm text-on-surface-variant">Sample 5 seasonal cake
                                    sponges and house-infused buttercream fillings delivered to your residence.</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-3.5">
                            <div class="w-6 h-6 rounded-full bg-secondary-fixed/60 flex items-center justify-center text-secondary mt-0.5 flex-shrink-0">
                                <span class="material-symbols-outlined text-[16px]">check</span>
                            </div>
                            <div>
                                <h4 class="font-label-lg text-label-lg font-semibold text-primary">Hand-Sketched
                                    Moodboard</h4>
                                <p class="font-body-sm text-body-sm text-on-surface-variant">Direct one-on-one
                                    collaboration with our pastry director to match event floral palettes and dress
                                    textures.</p>
                            </div>
                        </div>

                        <div class="flex items-start gap-3.5">
                            <div class="w-6 h-6 rounded-full bg-secondary-fixed/60 flex items-center justify-center text-secondary mt-0.5 flex-shrink-0">
                                <span class="material-symbols-outlined text-[16px]">check</span>
                            </div>
                            <div>
                                <h4 class="font-label-lg text-label-lg font-semibold text-primary">White-Glove
                                    Refrigerated Courier</h4>
                                <p class="font-body-sm text-body-sm text-on-surface-variant">Temperature-controlled
                                    dedicated delivery and on-site tiered assembly across the Western Province.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Booking Buttons -->
                    <div class="flex flex-wrap items-center gap-4">
                        <a class="bg-primary text-background font-label-lg text-label-lg px-8 py-3.5 rounded-full font-medium hover:bg-secondary hover:text-background active:scale-[0.98] transition-all flex items-center gap-2 shadow-sm"
                           href="${pageContext.request.contextPath}/bookCake">
                            <span class="material-symbols-outlined text-[18px]">calendar_month</span>
                            <span>Book a Custom Cake</span>
                        </a>
                        <a class="text-primary font-label-lg text-label-lg px-6 py-3.5 rounded-full font-medium border border-outline-variant/60 hover:bg-surface-container-lowest hover:text-secondary transition-all"
                           href="${pageContext.request.contextPath}/menu">
                            View Flavour Catalogue
                        </a>
                    </div>
                </div>
            </div>

            <!-- Live Interactive Cake Price Estimator Widget -->
            <div class="mt-16 bg-surface-container-lowest rounded-xl border border-outline-variant/30 p-6 sm:p-8 lg:p-10 shadow-luxury-card max-w-4xl mx-auto">
                <div class="flex flex-col sm:flex-row sm:items-center justify-between pb-6 border-b border-outline-variant/20 gap-3">
                    <div>
                        <span class="font-label-sm text-label-sm uppercase tracking-wider text-secondary font-semibold">Interactive Studio Calculator</span>
                        <h3 class="font-headline-sm text-[22px] font-semibold text-primary">Live Custom Cake Price
                            Estimator</h3>
                    </div>
                    <span class="inline-flex items-center gap-1.5 self-start sm:self-auto bg-surface-container-high text-secondary px-3 py-1 rounded-full font-label-sm text-label-sm font-semibold">
              <span class="w-2 h-2 rounded-full bg-secondary"></span>
              REAL-TIME ESTIMATE
            </span>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-6">
                    <!-- Flavor -->
                    <div>
                        <label for="estimatorFlavor"
                               class="block font-label-md text-label-md font-semibold text-primary mb-2">Flavor
                            Profile</label>
                        <select id="estimatorFlavor" onchange="updateEstimatorPrice()"
                                class="w-full bg-surface-container-low border border-outline-variant/40 rounded-lg px-4 py-2.5 text-body-md text-primary focus:outline-none focus:border-secondary">
                            <option value="Belgian Chocolate Truffle" selected>Belgian Chocolate Truffle (70% Ganache)
                            </option>
                            <option value="Madagascar Bourbon Vanilla">Madagascar Bourbon Vanilla Sponge</option>
                            <option value="Wild Strawberry Cloud">Wild Strawberry Chiffon Cloud</option>
                            <option value="Swiss Red Velvet">Swiss Red Velvet with Cream Cheese</option>
                            <option value="Pistachio & Fig Compote">Pistachio Sponge & Fig Compote</option>
                        </select>
                    </div>

                    <!-- Size -->
                    <div>
                        <label for="estimatorSize"
                               class="block font-label-md text-label-md font-semibold text-primary mb-2">Cake
                            Diameter</label>
                        <select id="estimatorSize" onchange="updateEstimatorPrice()"
                                class="w-full bg-surface-container-low border border-outline-variant/40 rounded-lg px-4 py-2.5 text-body-md text-primary focus:outline-none focus:border-secondary">
                            <option value="6">6-Inch (Serves 6 - 8 Guests)</option>
                            <option value="8" selected>8-Inch (Serves 8 - 12 Guests)</option>
                            <option value="10">10-Inch (Serves 14 - 18 Guests)</option>
                            <option value="12">12-Inch (Serves 20 - 26 Guests)</option>
                        </select>
                    </div>

                    <!-- Inscription -->
                    <div>
                        <label for="estimatorMessage"
                               class="block font-label-md text-label-md font-semibold text-primary mb-2">Piped Message
                            Preview</label>
                        <input type="text" id="estimatorMessage" placeholder="e.g. Happy 30th Birthday Sophia!"
                               maxlength="40"
                               class="w-full bg-surface-container-low border border-outline-variant/40 rounded-lg px-4 py-2.5 text-body-md text-primary focus:outline-none focus:border-secondary">
                    </div>
                </div>

                <!-- Calculation Bar & Action -->
                <div class="mt-6 pt-6 border-t border-outline-variant/20 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                    <div>
                        <p class="font-label-sm text-label-sm text-on-surface-variant uppercase">Estimated Base
                            Investment</p>
                        <div class="flex items-baseline gap-2">
                            <span id="estimatorDisplayPrice"
                                  class="font-headline-lg text-[32px] font-bold text-primary">Rs. 7,200</span>
                            <span id="estimatorServingNote" class="font-body-sm text-body-sm text-on-surface-variant">(Serves 8 - 12 guests)</span>
                        </div>
                    </div>
                    <button type="button" onclick="proceedToCakeStudio()"
                            class="bg-primary text-background font-label-lg px-7 py-3 rounded-full font-medium hover:bg-secondary hover:text-background active:scale-[0.98] transition-all flex items-center justify-center gap-2 shadow-sm">
                        <span class="material-symbols-outlined text-[18px]">magic_button</span>
                        <span>Customize in Cake Studio &rarr;</span>
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- ================= WHY CHOOSE US (TRUST PILLARS) ================= -->
    <section class="max-w-[1440px] mx-auto px-6 sm:px-8 lg:px-12 py-20 sm:py-24" id="about">
        <!-- Section Header -->
        <div class="text-center max-w-2xl mx-auto mb-16">
        <span class="font-label-sm text-label-sm uppercase tracking-widest text-secondary font-semibold mb-2 block">
          Our Uncompromising Promise
        </span>
            <h2 class="font-headline-lg text-headline-lg text-primary tracking-tight">
                Craftsmanship in Every Crumb
            </h2>
            <p class="font-body-md text-body-md text-on-surface-variant mt-3">
                We honor classical French viennoiserie methods while celebrating modern bespoke cake artistry.
            </p>
        </div>

        <!-- 4 Pillars Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            <!-- Pillar 1 -->
            <div class="bg-surface-container-lowest p-8 rounded-DEFAULT border border-outline-variant/30 shadow-luxury-card flex flex-col items-start hover:border-secondary transition-all">
                <div class="w-14 h-14 rounded-full bg-secondary-fixed/50 flex items-center justify-center text-secondary mb-6">
                    <span class="material-symbols-outlined text-[28px]">schedule</span>
                </div>
                <h3 class="font-headline-sm text-[20px] font-semibold text-primary mb-2">Freshly Baked Daily</h3>
                <p class="font-body-md text-body-md text-on-surface-variant">
                    Handcrafted every single dawn before dawn breaks. Our ovens never re-heat yesterday's lamination.
                </p>
            </div>

            <!-- Pillar 2 -->
            <div class="bg-surface-container-lowest p-8 rounded-DEFAULT border border-outline-variant/30 shadow-luxury-card flex flex-col items-start hover:border-secondary transition-all">
                <div class="w-14 h-14 rounded-full bg-secondary-fixed/50 flex items-center justify-center text-secondary mb-6">
                    <span class="material-symbols-outlined text-[28px]">workspace_premium</span>
                </div>
                <h3 class="font-headline-sm text-[20px] font-semibold text-primary mb-2">Made with Quality
                    Ingredients</h3>
                <p class="font-body-md text-body-md text-on-surface-variant">
                    Pure Normandy AOP cultured butter, single-origin cacao, Madagascar bourbon vanilla, and unbleached
                    grain.
                </p>
            </div>

            <!-- Pillar 3 -->
            <div class="bg-surface-container-lowest p-8 rounded-DEFAULT border border-outline-variant/30 shadow-luxury-card flex flex-col items-start hover:border-secondary transition-all">
                <div class="w-14 h-14 rounded-full bg-secondary-fixed/50 flex items-center justify-center text-secondary mb-6">
                    <span class="material-symbols-outlined text-[28px]">draw</span>
                </div>
                <h3 class="font-headline-sm text-[20px] font-semibold text-primary mb-2">Custom Designs for Every
                    Occasion</h3>
                <p class="font-body-md text-body-md text-on-surface-variant">
                    Bespoke tier architecture, hand-pressed edible florals, sugar lace, and tailored flavor journeys.
                </p>
            </div>

            <!-- Pillar 4 -->
            <div class="bg-surface-container-lowest p-8 rounded-DEFAULT border border-outline-variant/30 shadow-luxury-card flex flex-col items-start hover:border-secondary transition-all">
                <div class="w-14 h-14 rounded-full bg-secondary-fixed/50 flex items-center justify-center text-secondary mb-6">
                    <span class="material-symbols-outlined text-[28px]">shopping_bag</span>
                </div>
                <h3 class="font-headline-sm text-[20px] font-semibold text-primary mb-2">Convenient Online Ordering</h3>
                <p class="font-body-md text-body-md text-on-surface-variant">
                    Effortless scheduled dispatch date selection, real-time batch allocation, and secure instant LKR
                    checkout.
                </p>
            </div>
        </div>
    </section>

    <!-- ================= BOUTIQUE COUNTER & STORY ================= -->
    <section class="max-w-[1440px] mx-auto px-6 sm:px-8 lg:px-12 pb-20 sm:pb-24">
        <div class="bg-surface-container-low rounded-xl border border-outline-variant/30 p-8 sm:p-12 lg:p-16 text-center max-w-4xl mx-auto shadow-luxury-card">
        <span class="font-label-sm text-label-sm uppercase tracking-widest text-secondary font-semibold mb-2 block">
          There's Always a Reason
        </span>
            <h2 class="font-headline-lg text-headline-lg text-primary tracking-tight mb-4">
                Make today a little <span class="italic font-normal text-secondary">sweeter.</span>
            </h2>
            <p class="font-body-lg text-body-lg text-on-surface-variant max-w-xl mx-auto mb-8 leading-relaxed">
                Visit our boutique bakery counter in Colombo 03 or order ahead online for same-day scheduled
                refrigerated courier dispatch across Colombo.
            </p>
            <div class="flex flex-wrap items-center justify-center gap-4 mb-8">
                <a class="bg-primary text-background font-label-lg px-8 py-3.5 rounded-full font-medium hover:bg-secondary hover:text-background active:scale-[0.98] transition-all flex items-center gap-2 shadow-sm"
                   href="${pageContext.request.contextPath}/menu">
                    <span>Find Your Next Favourite</span>
                    <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                </a>
                <a class="border-2 border-secondary text-primary font-label-lg px-7 py-3.5 rounded-full font-medium hover:bg-surface-container-high hover:text-primary transition-all"
                   href="${pageContext.request.contextPath}/bookCake">
                    Book a Custom Cake
                </a>
            </div>
            <div class="inline-flex items-center gap-2 text-on-surface-variant font-label-md text-label-md">
                <span class="material-symbols-outlined text-secondary text-[20px]">location_on</span>
                <span>42 Alfred House Gardens, Colombo 03 &middot; Open daily, 7:00 AM &ndash; 8:00 PM</span>
            </div>
        </div>
    </section>
</main>

<!-- ================= GLOBAL FOOTER INCLUSION ================= -->
<jsp:include page="/WEB-INF/includes/footer.jsp"/>
</body>
</html>
