<script setup lang="ts">
import type { SharedData } from '@/types';
import { usePage } from '@inertiajs/vue3';
import { CheckCircle2, X } from 'lucide-vue-next';
import { computed, onBeforeUnmount, ref, watch } from 'vue';

const page = usePage<SharedData>();

const message = computed(() => page.props.flash?.success ?? null);
const visible = ref(false);

let timeout: ReturnType<typeof setTimeout> | undefined;

watch(
    message,
    (value) => {
        if (timeout) {
            clearTimeout(timeout);
        }

        visible.value = Boolean(value);

        if (value) {
            timeout = setTimeout(() => (visible.value = false), 4000);
        }
    },
    { immediate: true },
);

onBeforeUnmount(() => {
    if (timeout) {
        clearTimeout(timeout);
    }
});
</script>

<template>
    <Transition
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="-translate-y-2 opacity-0"
        leave-active-class="transition duration-200 ease-in"
        leave-to-class="-translate-y-2 opacity-0"
    >
        <div
            v-if="visible && message"
            role="status"
            aria-live="polite"
            class="mb-6 flex items-start gap-3 rounded-lg border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-900 dark:border-emerald-500/30 dark:bg-emerald-500/10 dark:text-emerald-100"
        >
            <CheckCircle2 class="mt-0.5 size-4 shrink-0" aria-hidden="true" />
            <p class="flex-1">{{ message }}</p>
            <button
                type="button"
                class="-m-1 rounded p-1 transition-colors hover:bg-emerald-100 dark:hover:bg-emerald-500/20"
                aria-label="Dismiss notification"
                @click="visible = false"
            >
                <X class="size-4" aria-hidden="true" />
            </button>
        </div>
    </Transition>
</template>
