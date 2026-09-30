<script setup lang="ts">
import InputError from '@/components/InputError.vue';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardFooter } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import AppLayout from '@/layouts/AppLayout.vue';
import { Head, Link, useForm } from '@inertiajs/vue3';
import { PenLine } from 'lucide-vue-next';

const form = useForm({
    title: '',
    content: '',
});

const submit = () => {
    form.post('/posts');
};
</script>

<template>
    <Head title="New post" />

    <AppLayout>
        <div class="mx-auto w-full max-w-2xl">
            <header class="mb-6 flex items-start gap-3">
                <span class="bg-primary/10 text-primary flex size-10 shrink-0 items-center justify-center rounded-lg">
                    <PenLine class="size-5" aria-hidden="true" />
                </span>
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Write a new post</h1>
                    <p class="text-muted-foreground text-sm">Give your article a clear title and share your thoughts.</p>
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
                            {{ form.processing ? 'Publishing…' : 'Publish post' }}
                        </Button>
                    </CardFooter>
                </form>
            </Card>
        </div>
    </AppLayout>
</template>
