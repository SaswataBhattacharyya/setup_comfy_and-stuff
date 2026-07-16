# Graph Report - sol_rasa  (2026-07-14)

## Corpus Check
- 255 files · ~629,764 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1776 nodes · 3517 edges · 144 communities (114 shown, 30 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 260 edges (avg confidence: 0.52)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `82319885`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]
- [[_COMMUNITY_Community 44|Community 44]]
- [[_COMMUNITY_Community 45|Community 45]]
- [[_COMMUNITY_Community 46|Community 46]]
- [[_COMMUNITY_Community 47|Community 47]]
- [[_COMMUNITY_Community 48|Community 48]]
- [[_COMMUNITY_Community 49|Community 49]]
- [[_COMMUNITY_Community 50|Community 50]]
- [[_COMMUNITY_Community 51|Community 51]]
- [[_COMMUNITY_Community 52|Community 52]]
- [[_COMMUNITY_Community 53|Community 53]]
- [[_COMMUNITY_Community 54|Community 54]]
- [[_COMMUNITY_Community 55|Community 55]]
- [[_COMMUNITY_Community 56|Community 56]]
- [[_COMMUNITY_Community 57|Community 57]]
- [[_COMMUNITY_Community 59|Community 59]]
- [[_COMMUNITY_Community 61|Community 61]]
- [[_COMMUNITY_Community 63|Community 63]]
- [[_COMMUNITY_Community 64|Community 64]]
- [[_COMMUNITY_Community 66|Community 66]]
- [[_COMMUNITY_Community 67|Community 67]]
- [[_COMMUNITY_Community 72|Community 72]]
- [[_COMMUNITY_Community 73|Community 73]]
- [[_COMMUNITY_Community 79|Community 79]]
- [[_COMMUNITY_Community 80|Community 80]]
- [[_COMMUNITY_Community 82|Community 82]]
- [[_COMMUNITY_Community 84|Community 84]]
- [[_COMMUNITY_Community 85|Community 85]]
- [[_COMMUNITY_Community 86|Community 86]]
- [[_COMMUNITY_Community 87|Community 87]]
- [[_COMMUNITY_Community 88|Community 88]]
- [[_COMMUNITY_Community 91|Community 91]]
- [[_COMMUNITY_Community 93|Community 93]]
- [[_COMMUNITY_Community 94|Community 94]]
- [[_COMMUNITY_Community 95|Community 95]]
- [[_COMMUNITY_Community 96|Community 96]]
- [[_COMMUNITY_Community 97|Community 97]]
- [[_COMMUNITY_Community 98|Community 98]]
- [[_COMMUNITY_Community 99|Community 99]]
- [[_COMMUNITY_Community 100|Community 100]]
- [[_COMMUNITY_Community 101|Community 101]]
- [[_COMMUNITY_Community 102|Community 102]]
- [[_COMMUNITY_Community 103|Community 103]]
- [[_COMMUNITY_Community 104|Community 104]]
- [[_COMMUNITY_Community 105|Community 105]]
- [[_COMMUNITY_Community 106|Community 106]]
- [[_COMMUNITY_Community 107|Community 107]]
- [[_COMMUNITY_Community 108|Community 108]]
- [[_COMMUNITY_Community 109|Community 109]]
- [[_COMMUNITY_Community 110|Community 110]]
- [[_COMMUNITY_Community 111|Community 111]]
- [[_COMMUNITY_Community 113|Community 113]]
- [[_COMMUNITY_Community 114|Community 114]]
- [[_COMMUNITY_Community 115|Community 115]]
- [[_COMMUNITY_Community 117|Community 117]]
- [[_COMMUNITY_Community 118|Community 118]]
- [[_COMMUNITY_Community 119|Community 119]]
- [[_COMMUNITY_Community 121|Community 121]]
- [[_COMMUNITY_Community 122|Community 122]]
- [[_COMMUNITY_Community 128|Community 128]]
- [[_COMMUNITY_Community 130|Community 130]]
- [[_COMMUNITY_Community 131|Community 131]]
- [[_COMMUNITY_Community 133|Community 133]]
- [[_COMMUNITY_Community 134|Community 134]]
- [[_COMMUNITY_Community 135|Community 135]]
- [[_COMMUNITY_Community 136|Community 136]]
- [[_COMMUNITY_Community 143|Community 143]]

## God Nodes (most connected - your core abstractions)
1. `cn()` - 70 edges
2. `User` - 31 edges
3. `Any` - 29 edges
4. `DeliveryError` - 28 edges
5. `require_staff()` - 24 edges
6. `Path` - 23 edges
7. `EncryptedTextField` - 23 edges
8. `Any` - 23 edges
9. `log()` - 23 edges
10. `useAuth()` - 23 edges

## Surprising Connections (you probably didn't know these)
- `read_product_folder()` --calls--> `image_url()`  [INFERRED]
  backend/adminhub/content.py → scripts/load_collection_assets.py
- `Meta` --uses--> `EncryptedTextField`  [INFERRED]
  backend/analytics/models.py → backend/common/fields.py
- `Command` --uses--> `User`  [INFERRED]
  backend/accounts/management/commands/bootstrap_superuser.py → backend/accounts/models.py
- `ModelPlan` --uses--> `Address`  [INFERRED]
  backend/accounts/management/commands/encrypt_pii_fields.py → backend/accounts/models.py
- `ModelPlan` --uses--> `User`  [INFERRED]
  backend/accounts/management/commands/encrypt_pii_fields.py → backend/accounts/models.py

## Import Cycles
- 1-file cycle: `backend/payments/services.py -> backend/payments/services.py`
- 1-file cycle: `backend/orders/services.py -> backend/orders/services.py`

## Communities (144 total, 30 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.12
Nodes (14): AbstractBaseUser, AddressAdmin, OtpChallengeAdmin, SolrasaAdminSite, UserAdmin, UserManager, Address, Meta (+6 more)

### Community 1 - "Community 1"
Cohesion: 0.08
Nodes (78): ensure_user_superuser_column(), catalog_version_digest(), _clamp_number(), _current_filters(), _default_publish_status(), delete_product(), display_name(), ensure_dir() (+70 more)

### Community 2 - "Community 2"
Cohesion: 0.06
Nodes (29): useIsMobile(), Separator, Sidebar, SidebarContent, SidebarContext, SidebarFooter, SidebarGroup, SidebarGroupAction (+21 more)

### Community 3 - "Community 3"
Cohesion: 0.04
Nodes (52): dependencies, class-variance-authority, clsx, cmdk, date-fns, embla-carousel-react, @hookform/resolvers, input-otp (+44 more)

### Community 4 - "Community 4"
Cohesion: 0.14
Nodes (13): brandWord, catalogBody, catalogHeading, footerNote, footerTagline, heroCtaLabel, heroQuote, mapDescription (+5 more)

### Community 5 - "Community 5"
Cohesion: 0.17
Nodes (12): brand, care, color, fit, material, productLine, sizes, stock_quantity (+4 more)

### Community 6 - "Community 6"
Cohesion: 0.17
Nodes (12): brand, care, color, fit, material, productLine, sizes, stock_quantity (+4 more)

### Community 7 - "Community 7"
Cohesion: 0.06
Nodes (30): AdminHub(), AdminPage, blobToDataUrl(), canvasToBlob(), compressedName(), defaultDeliveryRule(), defaultLandingImageSetting, defaultPaymentStructure() (+22 more)

### Community 8 - "Community 8"
Cohesion: 0.17
Nodes (12): green-sanctuary-vibhatsa, brand, care, color, fit, material, productLine, sizes (+4 more)

### Community 9 - "Community 9"
Cohesion: 0.11
Nodes (18): Cart, CartAdmin, CartItemInline, Cart, CartItem, Meta, cart_detail(), cart_sync() (+10 more)

### Community 10 - "Community 10"
Cohesion: 0.06
Nodes (21): NavLink, NavLinkCompatProps, AccordionContent, AccordionItem, AccordionTrigger, Avatar, AvatarFallback, AvatarImage (+13 more)

### Community 11 - "Community 11"
Cohesion: 0.10
Nodes (36): copy_images_to_public(), display_name(), ensure_dir(), generate_product_data(), image_sort_key(), image_url(), landing_asset_url(), load_landing_config() (+28 more)

### Community 12 - "Community 12"
Cohesion: 0.11
Nodes (24): Action, ActionType, actionTypes, addToRemoveQueue(), dispatch(), genId(), listeners, memoryState (+16 more)

### Community 13 - "Community 13"
Cohesion: 0.17
Nodes (12): odyssey-vira-adbhuta, brand, care, color, fit, material, productLine, sizes (+4 more)

### Community 14 - "Community 14"
Cohesion: 0.11
Nodes (30): setup_common.sh script, bootstrap_backend(), build_frontend(), ensure_base_apt_packages(), ensure_media_tooling(), ensure_node_runtime(), ensure_postgresql_database(), ensure_postgresql_runtime() (+22 more)

### Community 15 - "Community 15"
Cohesion: 0.17
Nodes (12): olive-rooted-vibhatsa, brand, care, color, fit, material, productLine, sizes (+4 more)

### Community 16 - "Community 16"
Cohesion: 0.17
Nodes (12): pink-beloved-shringara, brand, care, color, fit, material, productLine, sizes (+4 more)

### Community 17 - "Community 17"
Cohesion: 0.06
Nodes (44): FashionRailProps, AuthContext, AuthContextValue, AuthProvider(), PendingEmailAuth, CartContext, CartContextType, CartResponse (+36 more)

### Community 18 - "Community 18"
Cohesion: 0.10
Nodes (66): Any, Cart, Decimal, DeliveryMethod, Order, DeliveryCountryRule, country_name_for_code(), default_sender_country_code() (+58 more)

### Community 19 - "Community 19"
Cohesion: 0.08
Nodes (23): brandWord, catalogBody, catalogHeading, footerNote, footerTagline, heroCtaLabel, heroQuote, hideMap (+15 more)

### Community 20 - "Community 20"
Cohesion: 0.12
Nodes (23): cn(), AlertDialogAction, AlertDialogCancel, AlertDialogContent, AlertDialogDescription, AlertDialogFooter(), AlertDialogHeader(), AlertDialogOverlay (+15 more)

### Community 21 - "Community 21"
Cohesion: 0.08
Nodes (24): Cloudflare Origin Certificate, Dev Access for Admin Hub, Development Setup, Environment Notes, Garment folder structure, Garment spreadsheet, Google Login Setup, Homepage rail image folders (+16 more)

### Community 22 - "Community 22"
Cohesion: 0.17
Nodes (12): terracotta-daydream-hasya, brand, care, color, fit, material, productLine, sizes (+4 more)

### Community 23 - "Community 23"
Cohesion: 0.17
Nodes (12): wine-burgundy, brand, care, color, fit, material, productLine, sizes (+4 more)

### Community 24 - "Community 24"
Cohesion: 0.16
Nodes (12): browseLabel(), CatalogMeta, FashionMeta, MerchKey, ShowcaseItem, SiteContent, filterProductsByKey(), searchProducts() (+4 more)

### Community 25 - "Community 25"
Cohesion: 0.09
Nodes (21): compilerOptions, allowImportingTsExtensions, isolatedModules, jsx, lib, module, moduleDetection, moduleResolution (+13 more)

### Community 26 - "Community 26"
Cohesion: 0.08
Nodes (24): devDependencies, autoprefixer, eslint, @eslint/js, eslint-plugin-react-hooks, eslint-plugin-react-refresh, globals, jsdom (+16 more)

### Community 27 - "Community 27"
Cohesion: 0.12
Nodes (25): CollectionCard(), CollectionCardProps, RouteScrollManager(), CollectionFilters, CollectionProduct, filterLookup, filterSlug(), getFilteredProducts() (+17 more)

### Community 28 - "Community 28"
Cohesion: 0.12
Nodes (16): aliases, components, hooks, lib, ui, utils, rsc, $schema (+8 more)

### Community 29 - "Community 29"
Cohesion: 0.14
Nodes (12): Carousel, CarouselApi, CarouselContent, CarouselContext, CarouselContextProps, CarouselItem, CarouselNext, CarouselOptions (+4 more)

### Community 30 - "Community 30"
Cohesion: 0.11
Nodes (27): emptyAddress(), Settings(), Login(), Window, SupportDialogProps, useAuth(), CartProvider(), LanguageProvider() (+19 more)

### Community 31 - "Community 31"
Cohesion: 0.42
Nodes (14): copy_passthrough(), ensure_parent(), have_cmd(), iter_images(), main(), optimize_image(), optimize_video(), public_target_for() (+6 more)

### Community 32 - "Community 32"
Cohesion: 0.14
Nodes (11): FormControl, FormDescription, FormFieldContext, FormFieldContextValue, FormItem, FormItemContext, FormItemContextValue, FormLabel (+3 more)

### Community 33 - "Community 33"
Cohesion: 0.26
Nodes (7): ProductCard(), useCart(), useRoutePreloader(), UseRoutePreloaderOptions, formatPrice(), Cart(), ProductDetail()

### Community 34 - "Community 34"
Cohesion: 0.20
Nodes (9): DropdownMenuCheckboxItem, DropdownMenuContent, DropdownMenuItem, DropdownMenuLabel, DropdownMenuRadioItem, DropdownMenuSeparator, DropdownMenuShortcut(), DropdownMenuSubContent (+1 more)

### Community 35 - "Community 35"
Cohesion: 0.06
Nodes (80): google_login(), AdminOrderPdfRecipient, AdminExportLogAdmin, AnalyticsEventAdmin, CustomerProfileAdmin, ProductReviewAdmin, AdminExportLog, AdminOrderPdfRecipient (+72 more)

### Community 36 - "Community 36"
Cohesion: 0.09
Nodes (74): admin_delivery_methods_refresh(), Any, Decimal, DeliveryMethod, DeliveryReview, Order, OrderTrackingEvent, DeliveryReview (+66 more)

### Community 37 - "Community 37"
Cohesion: 0.19
Nodes (24): build_catalog(), build_site_content(), display_name(), env_flag(), image_sort_key(), main(), normalize_location(), parse_bool_text() (+16 more)

### Community 38 - "Community 38"
Cohesion: 0.12
Nodes (15): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+7 more)

### Community 39 - "Community 39"
Cohesion: 0.17
Nodes (11): Menubar, MenubarCheckboxItem, MenubarContent, MenubarItem, MenubarLabel, MenubarRadioItem, MenubarSeparator, MenubarShortcut() (+3 more)

### Community 40 - "Community 40"
Cohesion: 0.11
Nodes (18): mood_image, aspect, fit, position_x, position_y, zoom, philosophy_image, aspect (+10 more)

### Community 41 - "Community 41"
Cohesion: 0.18
Nodes (7): ChartConfig, ChartContainer, ChartContext, ChartContextProps, ChartLegendContent, ChartTooltipContent, THEMES

### Community 42 - "Community 42"
Cohesion: 0.17
Nodes (11): compilerOptions, allowJs, noImplicitAny, noUnusedLocals, noUnusedParameters, paths, skipLibCheck, strictNullChecks (+3 more)

### Community 43 - "Community 43"
Cohesion: 0.05
Nodes (25): LegalPageProps, LegalSection, bagSparks, collectionFilters, Navbar(), PreloaderContext, PreloaderContextValue, PreloaderProvider() (+17 more)

### Community 44 - "Community 44"
Cohesion: 0.25
Nodes (7): NavigationMenu, NavigationMenuContent, NavigationMenuIndicator, NavigationMenuList, NavigationMenuTrigger, navigationMenuTriggerStyle, NavigationMenuViewport

### Community 45 - "Community 45"
Cohesion: 0.12
Nodes (15): Command, CommandDialogProps, CommandEmpty, CommandGroup, CommandInput, CommandItem, CommandList, CommandSeparator (+7 more)

### Community 46 - "Community 46"
Cohesion: 0.33
Nodes (8): CookieConsentBanner(), defaultPreferences, analyticsConsentEnabled(), CookieConsentPreferences, getCookieConsent(), openCookiePreferences(), saveCookieConsent(), withDefaults()

### Community 47 - "Community 47"
Cohesion: 0.14
Nodes (13): AnalyticsHub(), AnalyticsView, AnyRecord, formatMoney(), isoDate(), metricLabels, navItems, thirtyDaysAgo (+5 more)

### Community 48 - "Community 48"
Cohesion: 0.13
Nodes (22): OtpChannel, _appwrite_phone_configured(), _appwrite_phone_user_id(), _appwrite_request(), create_challenge(), deliver_email_code(), deliver_sms_code(), generate_numeric_code() (+14 more)

### Community 49 - "Community 49"
Cohesion: 0.39
Nodes (7): restore_prod.sh script, main(), require_command(), start_backend_process(), stop_backend_processes(), usage(), validate_assets_archive()

### Community 50 - "Community 50"
Cohesion: 0.06
Nodes (32): filters, Bikinis, One-pieces, Resort, landingImages, 3rd_image.jpeg, SITE_02.jpeg, SITE_02.jpg.jpeg (+24 more)

### Community 51 - "Community 51"
Cohesion: 0.11
Nodes (11): decrypt_text(), encrypt_text(), EncryptedTextField, _field_encryption_key(), Migration, Migration, Migration, OrderAdmin (+3 more)

### Community 52 - "Community 52"
Cohesion: 0.36
Nodes (9): create_filters_xlsx(), create_pricing_xlsx(), ensure_dir(), main(), Path, Create pricing.xlsx with Size | Price columns., Create filters.xlsx with filter types as columns., Create a single product folder with all required files. (+1 more)

### Community 54 - "Community 54"
Cohesion: 0.20
Nodes (9): ContextMenuCheckboxItem, ContextMenuContent, ContextMenuItem, ContextMenuLabel, ContextMenuRadioItem, ContextMenuSeparator, ContextMenuShortcut(), ContextMenuSubContent (+1 more)

### Community 55 - "Community 55"
Cohesion: 0.29
Nodes (6): Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle

### Community 56 - "Community 56"
Cohesion: 0.15
Nodes (7): AccountsConfig, AnalyticsConfig, AppConfig, CartConfig, CatalogConfig, OrdersConfig, PaymentsConfig

### Community 57 - "Community 57"
Cohesion: 0.32
Nodes (11): setup_prod.sh script, ensure_initial_superuser(), generate_nginx_config(), install_nginx(), install_nginx_config(), install_offsite_backup_cron(), main(), require_noninteractive_root() (+3 more)

### Community 59 - "Community 59"
Cohesion: 0.22
Nodes (6): __dirname, __filename, images, imagesDir, items, outputPath

### Community 61 - "Community 61"
Cohesion: 0.22
Nodes (8): Table, TableBody, TableCaption, TableCell, TableFooter, TableHead, TableHeader, TableRow

### Community 64 - "Community 64"
Cohesion: 0.32
Nodes (4): BrandWordProps, useInView(), SplitShowcaseSection(), SplitShowcaseSectionProps

### Community 66 - "Community 66"
Cohesion: 0.60
Nodes (3): backup_offsite_prod.sh script, main(), require_command()

### Community 67 - "Community 67"
Cohesion: 0.17
Nodes (12): scripts, build, build:dev, content:sync, dev, generate:collection, lint, media:optimize (+4 more)

### Community 72 - "Community 72"
Cohesion: 0.21
Nodes (16): get_active_challenge(), mark_challenge_consumed(), address_detail(), address_set_default(), addresses(), email_change_verify(), email_verify(), ensure_one_default_address() (+8 more)

### Community 73 - "Community 73"
Cohesion: 0.16
Nodes (5): BaseCommand, Command, Command, ModelPlan, Command

### Community 79 - "Community 79"
Cohesion: 0.40
Nodes (4): categoryShowcase, colorShowcase, fashionMetadata, navCategories

### Community 80 - "Community 80"
Cohesion: 0.70
Nodes (4): setup_dev.sh script, choose_runtime_mode(), main(), run_services()

### Community 82 - "Community 82"
Cohesion: 0.21
Nodes (10): AppPreloader(), usePreloader(), VideoHero(), getMediaAsset(), mediaManifest, getOrderItemImage(), resolveMediaKey(), Orders() (+2 more)

### Community 94 - "Community 94"
Cohesion: 0.83
Nodes (3): backup_prod.sh script, main(), require_command()

### Community 96 - "Community 96"
Cohesion: 0.22
Nodes (8): SheetContent, SheetContentProps, SheetDescription, SheetFooter(), SheetHeader(), SheetOverlay, SheetTitle, sheetVariants

### Community 102 - "Community 102"
Cohesion: 0.33
Nodes (5): ToggleGroup, ToggleGroupContext, ToggleGroupItem, Toggle, toggleVariants

### Community 104 - "Community 104"
Cohesion: 0.83
Nodes (3): setup.sh script, choose_mode(), main()

### Community 106 - "Community 106"
Cohesion: 0.67
Nodes (3): add_missing_field(), Migration, repair_delivery_schema()

### Community 110 - "Community 110"
Cohesion: 0.40
Nodes (4): Alert, AlertDescription, AlertTitle, alertVariants

### Community 111 - "Community 111"
Cohesion: 0.25
Nodes (7): Breadcrumb, BreadcrumbEllipsis(), BreadcrumbItem, BreadcrumbLink, BreadcrumbList, BreadcrumbPage, BreadcrumbSeparator()

### Community 113 - "Community 113"
Cohesion: 0.25
Nodes (6): DrawerContent, DrawerDescription, DrawerFooter(), DrawerHeader(), DrawerOverlay, DrawerTitle

### Community 114 - "Community 114"
Cohesion: 0.50
Nodes (3): assets/hero_vid.mp4, assets/loading_solrasa.mp4, assets/solrasa_load.mp4

### Community 115 - "Community 115"
Cohesion: 0.50
Nodes (4): mostBoughtImages, newCollectionImages, sortedFolderImages(), listMediaFolder()

### Community 117 - "Community 117"
Cohesion: 0.40
Nodes (4): name, private, type, version

### Community 121 - "Community 121"
Cohesion: 0.29
Nodes (6): address, footerDomain, latitude, longitude, storeName, supportEmail

### Community 122 - "Community 122"
Cohesion: 0.67
Nodes (3): Badge(), BadgeProps, badgeVariants

## Knowledge Gaps
- **636 isolated node(s):** `fit`, `aspect`, `zoom`, `position_x`, `position_y` (+631 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **30 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `fashionMetadata` connect `Community 79` to `Community 5`, `Community 6`, `Community 8`, `Community 13`, `Community 15`, `Community 16`, `Community 22`, `Community 23`?**
  _High betweenness centrality (0.051) - this node is a cross-community bridge._
- **Why does `cn()` connect `Community 20` to `Community 2`, `Community 7`, `Community 10`, `Community 12`, `Community 29`, `Community 30`, `Community 32`, `Community 34`, `Community 39`, `Community 41`, `Community 44`, `Community 45`, `Community 54`, `Community 55`, `Community 61`, `Community 96`, `Community 102`, `Community 110`, `Community 111`, `Community 113`, `Community 122`?**
  _High betweenness centrality (0.036) - this node is a cross-community bridge._
- **Why does `blue-stillwater-shanta` connect `Community 5` to `Community 79`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._
- **Are the 23 inferred relationships involving `User` (e.g. with `AddressAdmin` and `OtpChallengeAdmin`) actually correct?**
  _`User` has 23 INFERRED edges - model-reasoned connections that need verification._
- **Are the 6 inferred relationships involving `Any` (e.g. with `DeliveryMethod` and `DeliveryProviderConfig`) actually correct?**
  _`Any` has 6 INFERRED edges - model-reasoned connections that need verification._
- **Are the 11 inferred relationships involving `DeliveryError` (e.g. with `DeliveryReview` and `Order`) actually correct?**
  _`DeliveryError` has 11 INFERRED edges - model-reasoned connections that need verification._
- **What connects `fit`, `aspect`, `zoom` to the rest of the system?**
  _653 weakly-connected nodes found - possible documentation gaps or missing edges._