<script setup lang="ts">
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import AppLayout from '@/layouts/AppLayout.vue';
import type { Post } from '@/types';
import { Head, Link } from '@inertiajs/vue3';
import { ArrowLeft, Pencil, UserRound } from 'lucide-vue-next';

const props = defineProps<{
    post: Post;
}>();

const formatDate = (value?: string) => (value ? new Date(value).toLocaleDateString('en-GB', { year: 'numeric', month: 'long', day: 'numeric' }) : '');
</script>

<template>
    <Head :title="props.post.title" />

    <AppLayout>
        <article class="mx-auto w-full max-w-3xl">
            <Button variant="ghost" size="sm" as-child class="text-muted-foreground mb-4 -ml-2">
                <Link href="/posts">
                    <ArrowLeft class="size-4" aria-hidden="true" />
                    Back to all posts
                </Link>
            </Button>

            <Card>
                <CardContent class="space-y-6">
                    <header class="border-border space-y-3 border-b pb-6">
                        <h1 class="text-3xl font-bold tracking-tight">{{ props.post.title }}</h1>
                        <p class="text-muted-foreground flex items-center gap-2 text-sm">
                            <UserRound class="size-4" aria-hidden="true" />
                            {{ props.post.user?.name ?? 'Unknown author' }}
                            <span aria-hidden="true">·</span>
                            <time :datetime="props.post.created_at">{{ formatDate(props.post.created_at) }}</time>
                        </p>
                    </header>

                    <div class="text-foreground text-base leading-relaxed whitespace-pre-line">{{ props.post.content }}</div>
                </CardContent>
            </Card>

            <div class="mt-4 flex justify-end">
                <Button as-child>
                    <Link :href="`/posts/${props.post.id}/edit`">
                        <Pencil class="size-4" aria-hidden="true" />
                        Edit post
                    </Link>
                </Button>
            </div>
        </article>
    </AppLayout>
</template>
