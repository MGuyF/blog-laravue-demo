<template>
    <div class="flex flex-col min-h-screen bg-muted font-sans text-gray-900">
        <!-- Header -->
        <header class="bg-white border-b border-gray-200 shadow-sm sticky top-0 z-10">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">

                <!-- Desktop Header -->
                <div class="hidden lg:flex items-center justify-between h-16">
                    <h1 class="text-xl font-bold text-primary">
                        <Link href="/posts">Mini Blog</Link>
                    </h1>
                    <nav class="flex items-center gap-6 text-sm font-medium">
                        <NavLinks />
                    </nav>
                </div>

                <!-- Mobile Header -->
                <div class="flex lg:hidden items-center justify-between h-16">
                    <h1 class="text-xl font-bold text-primary">
                        <Link href="/posts">Mini Blog</Link>
                    </h1>
                    <button @click="toggleMenu" class="text-gray-600 hover:text-gray-900 focus:outline-none">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"
                            stroke-linecap="round" stroke-linejoin="round">
                            <path d="M4 6h16M4 12h16M4 18h16" />
                        </svg>
                    </button>
                </div>

                <!-- Menu mobile déroulant -->
                <nav v-show="isOpen" class="lg:hidden w-full bg-white border-t border-gray-200 px-4 py-4">
                    <NavLinks />
                </nav>
            </div>
        </header>

        <!-- Page content -->
        <main class="flex-1">
            <div class="py-8 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto w-full">
                <slot />
            </div>
        </main>

        <!-- Footer -->
        <footer class="bg-white border-t border-gray-200 py-4 mt-10 text-center text-sm text-muted-foreground">
            © {{ new Date().getFullYear() }} Mini Blog. Tous droits réservés.
        </footer>
    </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';
import { router } from '@inertiajs/vue3';
import { usePage } from '@inertiajs/vue3'
import NavLinks from '@/components/NavLinks.vue'    

// Récupère les infos de l'utilisateur connecté
const { props } = usePage()
const user = props.auth.user

// Optionnel : image par défaut si pas d'avatar
const userAvatar = user.avatar ?? 'https://ui-avatars.com/api/?name=' + encodeURIComponent(user.name)

function logout() {
    router.post(route('logout'))
}

import { ref } from 'vue'

const isOpen = ref(false)

function toggleMenu() {
    isOpen.value = !isOpen.value
}
</script>
