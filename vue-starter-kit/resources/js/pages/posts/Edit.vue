<script setup lang="ts">
import InputError from '@/components/InputError.vue';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardFooter } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import AppLayout from '@/layouts/AppLayout.vue';
import type { Post } from '@/types';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { Pencil } from 'lucide-vue-next';

const props = defineProps<{
    post: Post;
}>();

const form = useForm({
    title: props.post.title,
    content: props.post.content,
});

const submit = () => {
    form.put(`/posts/${props.post.id}`);
};
</script>

<template>
    <Head title="Edit post" />

    <AppLayout>
        <div class="mx-auto w-full max-w-2xl">
            <header class="mb-6 flex items-start gap-3">
                <span class="bg-primary/10 text-primary flex size-10 shrink-0 items-center justify-center rounded-lg">
                    <Pencil class="size-5" aria-hidden="true" />
                </span>
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Edit post</h1>
                    <p class="text-muted-foreground text-sm">Update the title or the content of “{{ props.post.title }}”.</p>
                </div>
            </header>

            <Card>
                <form @submit.prevent="submit">
                    <CardContent class="space-y-5">
                        <div class="grid gap-2">
                            <Label for="title">Title</Label>
                            <Input
                                id="title"
                                v-model="form.title"
                                name="title"
                                type="text"
                                placeholder="An interesting title"
                                autofocus
                                :aria-invalid="Boolean(form.errors.title)"
                            />
                            <InputError :message="form.errors.title" />
                        </div>

                        <div class="grid gap-2">
                            <Label for="content">Content</Label>
                            <Textarea
                                id="content"
                                v-model="form.content"
                                name="content"
                                rows="8"
                                placeholder="Write your post content here…"
                                :aria-invalid="Boolean(form.errors.content)"
                            />
                            <InputError :message="form.errors.content" />
                        </div>
                    </CardContent>

                    <CardFooter class="mt-6 justify-end gap-2 border-t">
                        <Button variant="secondary" as-child>
                            <Link href="/posts">Cancel</Link>
                        </Button>

                        <Button type="submit" :disabled="form.processing">
                            {{ form.processing ? 'Saving…' : 'Save changes' }}
                        </Button>
                    </CardFooter>
                </form>
            </Card>
        </div>
    </AppLayout>
</template>
