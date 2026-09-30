<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Inertia\Testing\AssertableInertia as Assert;
use Tests\TestCase;

class PostTest extends TestCase
{
    use RefreshDatabase;

    public function test_guests_are_redirected_to_the_login_page()
    {
        $response = $this->get('/posts');

        $response->assertRedirect('/login');
    }

    public function test_authenticated_users_can_browse_the_posts_index()
    {
        $user = User::factory()->create();
        $post = $user->posts()->create([
            'title' => 'Hello world',
            'content' => 'My first article.',
        ]);

        $response = $this->actingAs($user)->get('/posts');

        $response->assertOk();
        $response->assertInertia(fn (Assert $page) => $page
            ->component('posts/Index')
            ->has('posts', 1)
            ->where('posts.0.id', $post->id)
            ->where('authUserId', $user->id));
    }

    public function test_authenticated_users_can_create_a_post()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->post('/posts', [
            'title' => 'Hello world',
            'content' => 'My first article.',
        ]);

        $response->assertRedirect('/posts');
        $response->assertSessionHas('success', 'Post published successfully.');
        $this->assertDatabaseHas('posts', [
            'title' => 'Hello world',
            'user_id' => $user->id,
        ]);
    }

    public function test_a_post_requires_a_title_and_content()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->post('/posts', []);

        $response->assertSessionHasErrors(['title', 'content']);
        $this->assertDatabaseCount('posts', 0);
    }

    public function test_authenticated_users_can_update_a_post()
    {
        $user = User::factory()->create();
        $post = $user->posts()->create([
            'title' => 'Old title',
            'content' => 'Old content.',
        ]);

        $response = $this->actingAs($user)->put("/posts/{$post->id}", [
            'title' => 'New title',
            'content' => 'Updated content.',
        ]);

        $response->assertRedirect('/posts');
        $response->assertSessionHas('success', 'Post updated successfully.');
        $this->assertDatabaseHas('posts', [
            'id' => $post->id,
            'title' => 'New title',
        ]);
    }

    public function test_authenticated_users_can_delete_a_post()
    {
        $user = User::factory()->create();
        $post = $user->posts()->create([
            'title' => 'Hello world',
            'content' => 'My first article.',
        ]);

        $response = $this->actingAs($user)->delete("/posts/{$post->id}");

        $response->assertRedirect('/posts');
        $response->assertSessionHas('success', 'Post deleted successfully.');
        $this->assertDatabaseCount('posts', 0);
    }
}
