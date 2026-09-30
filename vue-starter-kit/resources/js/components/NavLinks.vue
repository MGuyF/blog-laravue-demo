<script setup lang="ts">
import type { SharedData } from '@/types';
import { Link, router, usePage } from '@inertiajs/vue3';
import { LayoutDashboard, LogOut, Newspaper, Plus } from 'lucide-vue-next';

const { url, props } = usePage<SharedData>();
const user = props.auth.user;

const userAvatar = user.avatar ?? 'https://ui-avatars.com/api/?name=' + encodeURIComponent(user.name);

const links = [
    { label: 'All posts', href: '/posts', icon: Newspaper },
    { label: 'New post', href: '/posts/create', icon: Plus },
    { label: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
];

const isActive = (href: string) => {
    if (href === '/posts') {
        return url.startsWith('/posts') && !url.startsWith('/posts/create');
    }

    return url.startsWith(href);
};

function logout() {
    router.post(route('logout'));
}
</script>

<template>
    <div class="flex flex-col items-start gap-4 lg:flex-row lg:items-center lg:gap-6">
        <Link
            v-for="link in links"
            :key="link.href"
            :href="link.href"
            :aria-current="isActive(link.href) ? 'page' : undefined"
            :class="[
                'hover:text-primary flex items-center gap-2 border-b-2 pb-1 transition-colors',
                isActive(link.href) ? 'text-primary border-blue-500' : 'text-muted-foreground border-transparent',
            ]"
        >
            <component :is="link.icon" class="size-4" aria-hidden="true" />
            {{ link.label }}
        </Link>

        <form class="inline" @submit.prevent="logout">
            <button
                type="submit"
                class="flex items-center gap-2 border-b-2 border-transparent pb-1 text-red-500 transition-colors hover:text-red-700 dark:text-red-400 dark:hover:text-red-300"
            >
                <LogOut class="size-4" aria-hidden="true" />
                Log out
            </button>
        </form>

        <div class="bg-muted ml-0 flex items-center gap-3 rounded-full px-3 py-1 lg:ml-5">
            <img :src="userAvatar" :alt="`${user.name}'s avatar`" class="size-8 rounded-full object-cover" />
            <span class="text-sm font-medium">{{ user.name }}</span>
        </div>
    </div>
</template>
