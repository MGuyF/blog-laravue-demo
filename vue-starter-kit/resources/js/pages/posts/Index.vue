<script setup lang="ts">
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Dialog, DialogClose, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import AppLayout from '@/layouts/AppLayout.vue';
import type { Post } from '@/types';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { FileText, Pencil, Plus, Trash2 } from 'lucide-vue-next';
import { ref } from 'vue';

const props = defineProps<{
    posts: Post[];
    authUserId: number | null;
}>();

const postToDelete = ref<Post | null>(null);
const deleteForm = useForm({});

const authorName = (post: Post) => (post.user?.id === props.authUserId ? 'You' : (post.user?.name ?? 'Unknown author'));

const formatDate = (value?: string) =>
    value ? new Date(value).toLocaleDateString('en-GB', { year: 'numeric', month: 'short', day: 'numeric' }) : '';

const confirmDelete = () => {
    if (!postToDelete.value) {
        return;
    }

    deleteForm.delete(`/posts/${postToDelete.value.id}`, {
        preserveScroll: true,
        onSuccess: () => (postToDelete.value = null),
    });
};
</script>

<template>
    <Head title="All posts" />

    <AppLayout>
        <div class="flex flex-col gap-6">
            <header class="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">All posts</h1>
                    <p class="text-muted-foreground mt-1 text-sm">
                        {{ props.posts.length }} {{ props.posts.length === 1 ? 'post' : 'posts' }} published by the community.
                    </p>
                </div>

                <Button as-child>
                    <Link href="/posts/create">
                        <Plus class="size-4" aria-hidden="true" />
                        New post
                    </Link>
                </Button>
            </header>

            <div
                v-if="props.posts.length === 0"
                class="border-border bg-card flex flex-col items-center gap-3 rounded-xl border border-dashed px-6 py-14 text-center"
            >
                <span class="bg-muted text-muted-foreground flex size-12 items-center justify-center rounded-full">
                    <FileText class="size-6" aria-hidden="true" />
                </span>
                <h2 class="text-lg font-semibold">No posts yet</h2>
                <p class="text-muted-foreground max-w-sm text-sm">
                    Once an article is published it will show up here. Be the first to share something.
                </p>
                <Button as-child class="mt-2">
                    <Link href="/posts/create">Write the first post</Link>
                </Button>
            </div>

            <div v-else class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
                <Card v-for="post in props.posts" :key="post.id" class="gap-4">
                    <CardHeader>
                        <CardTitle class="text-base">
                            <Link :href="`/posts/${post.id}`" class="hover:text-primary transition-colors">
                                {{ post.title }}
                            </Link>
                        </CardTitle>
                        <CardDescription>By {{ authorName(post) }} · {{ formatDate(post.created_at) }}</CardDescription>
                    </CardHeader>

                    <CardContent>
                        <p class="text-muted-foreground line-clamp-3 text-sm whitespace-pre-line">{{ post.content }}</p>
                    </CardContent>

                    <CardFooter class="mt-auto gap-2">
                        <Button variant="secondary" size="sm" as-child>
                            <Link :href="`/posts/${post.id}`">Read</Link>
                        </Button>

                        <Button variant="ghost" size="sm" as-child>
                            <Link :href="`/posts/${post.id}/edit`">
                                <Pencil class="size-4" aria-hidden="true" />
                                Edit
                            </Link>
                        </Button>

                        <Button variant="ghost" size="sm" class="text-destructive hover:text-destructive ml-auto" @click="postToDelete = post">
                            <Trash2 class="size-4" aria-hidden="true" />
                            <span class="sr-only sm:not-sr-only">Delete</span>
                        </Button>
                    </CardFooter>
                </Card>
            </div>
        </div>

        <Dialog :open="postToDelete !== null" @update:open="(open) => !open && (postToDelete = null)">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete this post?</DialogTitle>
                    <DialogDescription> “{{ postToDelete?.title }}” will be permanently deleted. This action cannot be undone. </DialogDescription>
                </DialogHeader>

                <DialogFooter class="gap-2">
                    <DialogClose as-child>
                        <Button variant="secondary">Cancel</Button>
                    </DialogClose>

                    <Button variant="destructive" :disabled="deleteForm.processing" @click="confirmDelete">
                        {{ deleteForm.processing ? 'Deleting…' : 'Delete post' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>
