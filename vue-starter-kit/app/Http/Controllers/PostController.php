<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Auth;

class PostController extends Controller
{
    // Affiche tous les posts avec l'utilisateur connecté
    public function index()
    {
        return Inertia::render('posts/Index', [
            'posts' => Post::with('user')->latest()->get(),
            'authUserId' => Auth::id(),
        ]);
    }

    // Affiche le formulaire de création
    public function create()
    {
        return Inertia::render('posts/Create');
    }

    // Enregistre un nouveau post
        public function store(Request $request)
        {
            $validated = $request->validate([
                'title' => 'required',
                'content' => 'required',
            ]);

            Auth::user()->posts()->create($validated);

            return redirect()->route('posts.index');
        }

    // Affiche un post unique
    public function show(Post $post)
    {
        return Inertia::render('posts/Show', ['post' => $post->load('user')]);
    }


    // 🔍 Afficher la page d’édition
    public function edit(Post $post)
    {
        return Inertia::render('posts/Edit', [
            'post' => $post
        ]);
    }

    // ✏️ Mettre à jour un post
    public function update(Request $request, Post $post)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        $post->update($validated);

        return redirect()->route('posts.index')->with('success', 'Article mis à jour avec succès !');
    }

    // ❌ Supprimer un post
    public function destroy(Post $post)
    {
        $post->delete();

        return redirect()->route('posts.index')->with('success', 'Article supprimé avec succès !');
    }
}
