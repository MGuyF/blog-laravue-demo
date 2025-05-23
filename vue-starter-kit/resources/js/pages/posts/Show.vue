<template>
    <Head title="Post" />
    <AppLayout>
        <div class="p-6 max-w-2xl mx-auto">
            <Card>
                <CardContent>
                    <h1 class="text-3xl font-bold mb-4">{{ post.title }}</h1>
                    <p class="text-gray-700 leading-relaxed">{{ post.content }}</p>
                </CardContent>
            </Card>
            <Button type="button" class="mt-2" @click="$inertia.visit('/posts')">Retour</Button>
        </div>
    </AppLayout>
</template>

<script setup>
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Head } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';

defineProps({
    post: Object
});
</script>
