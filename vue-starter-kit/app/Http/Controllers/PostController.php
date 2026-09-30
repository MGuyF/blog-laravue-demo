<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class PostController extends Controller
{
    /**
     * Display every post together with its author.
     */
    public function index()
    {
        return Inertia::render('posts/Index', [
            'posts' => Post::with('user')->latest()->get(),
            'authUserId' => Auth::id(),
        ]);
    }

    /**
     * Show the post creation form.
     */
    public function create()
    {
        return Inertia::render('posts/Create');
    }

    /**
     * Store a newly created post for the authenticated user.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        Auth::user()->posts()->create($validated);

        return redirect()->route('posts.index')->with('success', 'Post published successfully.');
    }

    /**
     * Display a single post.
     */
    public function show(Post $post)
    {
        return Inertia::render('posts/Show', ['post' => $post->load('user')]);
    }

    /**
     * Show the post edition form.
     */
    public function edit(Post $post)
    {
        return Inertia::render('posts/Edit', [
            'post' => $post,
        ]);
    }

    /**
     * Update an existing post.
     */
    public function update(Request $request, Post $post)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        $post->update($validated);

        return redirect()->route('posts.index')->with('success', 'Post updated successfully.');
    }

    /**
     * Delete a post.
     */
    public function destroy(Post $post)
    {
        $post->delete();

        return redirect()->route('posts.index')->with('success', 'Post deleted successfully.');
    }
}
