<script setup lang="ts">
import Breadcrumbs from '@/components/Breadcrumbs.vue';
import FlashMessage from '@/components/FlashMessage.vue';
import NavLinks from '@/components/NavLinks.vue';
import type { BreadcrumbItem, SharedData } from '@/types';
import { Link, usePage } from '@inertiajs/vue3';
import { BookOpen, Menu, X } from 'lucide-vue-next';
import { ref, watch } from 'vue';

withDefaults(
    defineProps<{
        breadcrumbs?: BreadcrumbItem[];
    }>(),
    {
        breadcrumbs: () => [],
    },
);

const page = usePage<SharedData>();
const isOpen = ref(false);

watch(
    () => page.url,
    () => (isOpen.value = false),
);
</script>

<template>
    <div class="bg-muted/40 text-foreground flex min-h-screen flex-col">
        <a
            href="#main-content"
            class="focus:bg-background sr-only focus:not-sr-only focus:absolute focus:top-2 focus:left-2 focus:z-50 focus:rounded-md focus:px-4 focus:py-2 focus:text-sm focus:font-medium focus:shadow-lg"
        >
            Skip to content
        </a>

        <header class="border-border bg-background/95 supports-[backdrop-filter]:bg-background/80 sticky top-0 z-40 border-b backdrop-blur">
            <div class="mx-auto flex h-16 max-w-7xl items-center justify-between gap-4 px-4 sm:px-6 lg:px-8">
                <Link
                    href="/posts"
                    class="hover:text-primary focus-visible:ring-ring/50 flex items-center gap-2 rounded-md text-lg font-semibold transition-colors focus-visible:ring-[3px] focus-visible:outline-none"
                >
                    <span class="bg-primary text-primary-foreground flex size-9 items-center justify-center rounded-lg">
                        <BookOpen class="size-5" aria-hidden="true" />
                    </span>
                    <span>Mini Blog</span>
                </Link>

                <nav class="hidden lg:block" aria-label="Main navigation">
                    <NavLinks />
                </nav>

                <button
                    type="button"
                    class="text-muted-foreground hover:bg-accent hover:text-accent-foreground focus-visible:ring-ring/50 inline-flex size-9 items-center justify-center rounded-md transition-colors focus-visible:ring-[3px] focus-visible:outline-none lg:hidden"
                    :aria-expanded="isOpen"
                    aria-controls="mobile-navigation"
                    :aria-label="isOpen ? 'Close navigation menu' : 'Open navigation menu'"
                    @click="isOpen = !isOpen"
                >
                    <X v-if="isOpen" class="size-5" aria-hidden="true" />
                    <Menu v-else class="size-5" aria-hidden="true" />
                </button>
            </div>

            <nav
                v-show="isOpen"
                id="mobile-navigation"
                class="border-border bg-background border-t px-4 py-4 lg:hidden"
                aria-label="Mobile navigation"
            >
                <NavLinks />
            </nav>
        </header>

        <main id="main-content" class="flex-1">
            <div class="mx-auto w-full max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
                <FlashMessage />

                <div v-if="breadcrumbs?.length" class="mb-6">
                    <Breadcrumbs :breadcrumbs="breadcrumbs" />
                </div>

                <slot />
            </div>
        </main>

        <footer class="border-border bg-background text-muted-foreground border-t py-4 text-center text-sm">
            © {{ new Date().getFullYear() }} Mini Blog. All rights reserved.
        </footer>
    </div>
</template>
