<?php

use App\Http\Controllers\PostController;
use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function (Request $request) {
    if ($request->user()) {
        return redirect()->route('posts.index');
    }

    return Inertia::render('auth/Login', [
        'canResetPassword' => Route::has('password.request'),
        'status' => $request->session()->get('status'),
    ]);
})->name('home');

Route::get('dashboard', function (Request $request) {
    $posts = Post::with('user')->latest()->get();

    return Inertia::render('Dashboard', [
        'stats' => [
            'total' => $posts->count(),
            'mine' => $posts->where('user_id', $request->user()->id)->count(),
        ],
        'latestPosts' => $posts->take(5)->map(fn (Post $post) => [
            'id' => $post->id,
            'title' => $post->title,
            'author' => $post->user?->name,
            'created_at' => $post->created_at->toIso8601String(),
        ])->values(),
    ]);
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware(['auth', 'verified'])->group(function () {
    Route::get('/posts', [PostController::class, 'index'])->name('posts.index');
    Route::get('/posts/create', [PostController::class, 'create'])->name('posts.create');
    Route::post('/posts', [PostController::class, 'store'])->name('posts.store');
    Route::get('/posts/{post}', [PostController::class, 'show'])->name('posts.show');
    Route::get('/posts/{post}/edit', [PostController::class, 'edit'])->name('posts.edit');
    Route::put('/posts/{post}', [PostController::class, 'update'])->name('posts.update');
    Route::delete('/posts/{post}', [PostController::class, 'destroy'])->name('posts.destroy');
});

require __DIR__.'/settings.php';
require __DIR__.'/auth.php';
