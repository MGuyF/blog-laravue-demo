<script setup lang="ts">
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import AppLayout from '@/layouts/AppLayout.vue';
import { Head, Link } from '@inertiajs/vue3';
import { CalendarDays, FileText, PenLine, UserRound } from 'lucide-vue-next';

interface DashboardPost {
    id: number;
    title: string;
    author: string | null;
    created_at: string;
}

const props = defineProps<{
    stats: { total: number; mine: number };
    latestPosts: DashboardPost[];
}>();

const formatDate = (value: string) => new Date(value).toLocaleDateString('en-GB', { year: 'numeric', month: 'short', day: 'numeric' });
</script>

<template>
    <Head title="Dashboard" />

    <AppLayout>
        <div class="flex flex-col gap-6">
            <header class="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Dashboard</h1>
                    <p class="text-muted-foreground mt-1 text-sm">A quick overview of what has been published so far.</p>
                </div>

                <Button as-child>
                    <Link href="/posts/create">
                        <PenLine class="size-4" aria-hidden="true" />
                        New post
                    </Link>
                </Button>
            </header>

            <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                <Card>
                    <CardHeader>
                        <CardDescription class="flex items-center gap-2">
                            <FileText class="size-4" aria-hidden="true" />
                            Total posts
                        </CardDescription>
                        <CardTitle class="text-3xl">{{ props.stats.total }}</CardTitle>
                    </CardHeader>
                </Card>

                <Card>
                    <CardHeader>
                        <CardDescription class="flex items-center gap-2">
                            <UserRound class="size-4" aria-hidden="true" />
                            Written by you
                        </CardDescription>
                        <CardTitle class="text-3xl">{{ props.stats.mine }}</CardTitle>
                    </CardHeader>
                </Card>

                <Card class="sm:col-span-2 lg:col-span-1">
                    <CardHeader>
                        <CardDescription class="flex items-center gap-2">
                            <CalendarDays class="size-4" aria-hidden="true" />
                            Latest activity
                        </CardDescription>
                        <CardTitle class="text-base">{{ props.latestPosts[0]?.title ?? 'No posts yet' }}</CardTitle>
                    </CardHeader>
                </Card>
            </div>

            <Card>
                <CardHeader>
                    <CardTitle>Recent posts</CardTitle>
                    <CardDescription>The five most recently published articles.</CardDescription>
                </CardHeader>

                <CardContent>
                    <ul v-if="props.latestPosts.length" class="divide-border divide-y">
                        <li
                            v-for="post in props.latestPosts"
                            :key="post.id"
                            class="flex items-center justify-between gap-4 py-3 first:pt-0 last:pb-0"
                        >
                            <Link :href="`/posts/${post.id}`" class="hover:text-primary truncate text-sm font-medium transition-colors">
                                {{ post.title }}
                            </Link>
                            <span class="text-muted-foreground shrink-0 text-xs">
                                {{ post.author ?? 'Unknown author' }} · {{ formatDate(post.created_at) }}
                            </span>
                        </li>
                    </ul>

                    <p v-else class="text-muted-foreground text-sm">Nothing has been published yet.</p>
                </CardContent>
            </Card>
        </div>
    </AppLayout>
</template>
