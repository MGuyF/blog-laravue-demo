<template>
    <Head title="Modifier" />
    <AppLayout>
        <div class="p-6 max-w-2xl mx-auto">
            <!-- 🔹 Titre stylisé avec icône -->
            <h1 class="text-xl font-bold mb-6 flex items-center gap-2 text-gray-800">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-blue-500" fill="none" viewBox="0 0 24 24"
                    stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 20h9" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M16.5 3.5a2.121 2.121 0 113 3L6.5 20.5H3v-3L16.5 3.5z" />
                </svg>
                Modifier l'article
            </h1>

            <!-- 📝 Formulaire -->
            <form @submit.prevent="submit">
                <div class="space-y-4">

                    <!-- 🔸 Titre -->
                    <div>
                        <label for="title" class="block text-sm font-medium text-gray-700 mb-1 flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-500" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M3 6h18M3 12h18M3 18h18" />
                            </svg>
                            Titre
                        </label>
                        <input v-model="form.title" id="title" type="text"
                            class="w-full bg-white p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
                    </div>

                    <!-- 🔸 Contenu -->
                    <div>
                        <label for="content"
                            class="block text-sm font-medium text-gray-700 mb-1 flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-gray-500" fill="none"
                                viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M4 4h16v16H4z" />
                            </svg>
                            Contenu
                        </label>
                        <textarea v-model="form.content" id="content" rows="5"
                            class="w-full bg-white p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                    </div>

                    <!-- 🔘 Bouton -->
                    <div class="flex justify-end gap-3">
                        <Button type="button" class="mt-2" @click="$inertia.visit('/posts')">Retour</Button>

                        <Button type="submit" class="mt-2">Mettre à jour</Button>
                    </div>

                </div>
            </form>
        </div>
    </AppLayout>
</template>

<script setup>
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';
import { Button } from '@/components/ui/button';
import { Head } from '@inertiajs/vue3';
import { defineProps } from 'vue';

const props = defineProps({
    post: Object,
});

const form = useForm({
    title: props.post.title,
    content: props.post.content,
});

function submit() {
    form.put(`/posts/${props.post.id}`);
}
</script>
