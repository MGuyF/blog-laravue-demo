<!-- resources/js/components/NavLinks.vue -->
<template>
    <div class="flex flex-col lg:flex-row items-start lg:items-center gap-4 lg:gap-6">
        <Link href="/posts" :class="[
            'flex items-center gap-2 hover:text-primary pb-1',
            url === '/posts' ? 'border-b-3 border-blue-500' : ''
        ]">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5h14M5 12h14M5 19h14" />
        </svg>
        Articles
        </Link>

        <Link href="/posts/create" :class="[
            'flex items-center gap-2 hover:text-primary pb-1',
            url === '/posts/create' ? 'border-b-3 border-blue-500' : ''
        ]">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
        </svg>
        Créer
        </Link>

        <form @submit.prevent="logout" class="inline">
            <button type="submit" class="flex items-center gap-2 text-red-500 hover:text-red-700">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M17 16l4-4m0 0l-4-4m4 4H7" />
                </svg>
                Déconnexion
            </button>
        </form>

        <div
            class="flex items-center gap-3 bg-gray-100 dark:bg-gray-800 px-3 py-1 rounded-full mt-4 lg:mt-0 ml-0 lg:ml-5">
            <img :src="userAvatar" alt="avatar" class="w-8 h-8 rounded-full object-cover" />
            <span class="text-sm font-medium text-gray-800 dark:text-gray-200">{{ user.name }}</span>
        </div>
    </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
import { usePage, router } from '@inertiajs/vue3'

const { url, props } = usePage()
const user = props.auth.user
const userAvatar = user.avatar ?? 'https://ui-avatars.com/api/?name=' + encodeURIComponent(user.name)

function logout() {
    router.post(route('logout'))
}
</script>