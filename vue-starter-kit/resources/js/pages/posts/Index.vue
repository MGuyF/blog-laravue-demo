<template>
    <Head title="Posts" />
    <AppLayout>
        <div class="p-6">
            <!-- 🔹 Titre principal -->
            <h1 style="font-size: 1.4rem;" class="text-xl font-bold mb-4 flex items-center gap-2 text-gray-800">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-500" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M7 8h10M7 12h4m1 8H6a2 2 0 01-2-2V6a2 2 0 012-2h12a2 2 0 012 2v8" />
                </svg>
                Tous les articles
            </h1>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <Card v-for="post in posts" :key="post.id">
                    <CardContent class="p-4">
                        <!-- 🔸 Titre avec icône -->
                        <div class="flex items-center gap-2 text-lg font-semibold text-gray-800">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-indigo-500" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M4 6h16M4 12h8m-8 6h16" />
                            </svg>
                            {{ post.title }}
                        </div>

                        <!-- 🔸 Contenu avec icône -->
                        <div class="flex gap-2 mt-2 text-sm text-gray-600">
                            <div class="pt-0.5">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-400 flex-shrink-0"
                                    fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M8 10h.01M12 10h.01M16 10h.01M9 16h6m-9 4h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                            </div>
                            <p class="line-clamp-3">{{ post.content }}</p>
                        </div>


                        <!-- 👤 Auteur -->
                        <p
                            class="flex items-center gap-2 mt-4 px-3 py-2 text-sm text-gray-700 bg-gray-100 border-l-4 border-blue-500 rounded">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-blue-500" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M5.121 17.804A8.994 8.994 0 0012 21a8.994 8.994 0 006.879-3.196M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                            </svg>
                            Publié par :
                            <span class="font-medium ml-1">
                                <span v-if="post.user?.id === authUserId">Vous</span>
                                <span v-else>{{ post.user?.name }}</span>
                            </span>
                        </p>

                        <!-- 🔹 Actions -->
                        <div class="flex gap-4 mt-4 text-sm flex-wrap">
                            <!-- Lire -->
                            <Link :href="`/posts/${post.id}`"
                                class="inline-flex items-center text-blue-600 hover:underline gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M17 8l4 4m0 0l-4 4m4-4H3" />
                            </svg>
                            Lire
                            </Link>

                            <!-- Modifier -->
                            <Link :href="`/posts/${post.id}/edit`"
                                class="inline-flex items-center text-yellow-600 hover:underline gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24"
                                stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-5.5-9.5L19 9l-7 7H6v-6l7-7z" />
                            </svg>
                            Modifier
                            </Link>

                            <!-- Supprimer -->
                            <button @click="deletePost(post.id)"
                                class="inline-flex items-center text-red-600 hover:underline gap-1">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24"
                                    stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M6 18L18 6M6 6l12 12" />
                                </svg>
                                Supprimer
                            </button>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </div>


    </AppLayout>
</template>

<script setup>
import { Card, CardContent } from '@/components/ui/card';
import { Link } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { Head } from '@inertiajs/vue3';

defineProps({
    posts: Array,
    authUserId: Number,
});

import { router } from '@inertiajs/vue3';

const deletePost = (id) => {
    if (confirm('Voulez-vous vraiment supprimer cet article ?')) {
        router.delete(`/posts/${id}`);
    }
}


</script>