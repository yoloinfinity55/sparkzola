#!/bin/bash

# ==========================================
# Update SparkZola Homepage to Grid Layout
# ==========================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

cd /Users/minijohn/Documents/github-repo/sparkzola

print_step "Updating homepage template..."

# Backup existing template
if [ -f "templates/index.html" ]; then
    cp templates/index.html templates/index.html.backup
    print_success "Backed up existing template"
fi

# Create new grid-based homepage
cat > templates/index.html <<'EOF'
{% extends "base.html" %}

{% block content %}
<!-- Hero Section -->
<div class="mb-16">
  <div class="prose prose-lg max-w-none">
    {{ section.content | safe }}
  </div>
</div>

<!-- Blog Posts Grid -->
<div class="mb-12">
  <div class="flex justify-between items-center mb-8">
    <h2 class="text-3xl font-bold text-gray-900">Recent Posts</h2>
    <a href="{{ get_url(path="@/blog/_index.md") }}" class="text-blue-600 hover:text-blue-800 font-medium">
      View all →
    </a>
  </div>
  
  {% set blog = get_section(path="blog/_index.md") %}
  
  {% if blog.pages %}
  <!-- Grid Layout: 1 column on mobile, 2 on tablet, 3 on desktop -->
  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    {% for page in blog.pages | slice(end=6) %}
    <article class="bg-white rounded-lg shadow-md hover:shadow-xl transition-shadow duration-300 overflow-hidden flex flex-col">
      <!-- Gradient Header -->
      <div class="w-full h-48 bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center">
        <span class="text-white text-6xl font-bold opacity-20">{{ page.title | truncate(length=1, end="") }}</span>
      </div>
      
      <!-- Card Content -->
      <div class="p-6 flex-1 flex flex-col">
        <!-- Date Badge -->
        <div class="mb-3">
          <time datetime="{{ page.date }}" class="text-xs font-semibold text-blue-600 uppercase tracking-wide">
            {{ page.date | date(format="%b %d, %Y") }}
          </time>
        </div>
        
        <!-- Title -->
        <h3 class="text-xl font-bold text-gray-900 mb-3 hover:text-blue-600 transition">
          <a href="{{ page.permalink }}">{{ page.title }}</a>
        </h3>
        
        <!-- Description -->
        <p class="text-gray-600 text-sm mb-4 flex-1">
          {{ page.description | default(value="") | truncate(length=120) }}
        </p>
        
        <!-- Read More Link -->
        <a href="{{ page.permalink }}" class="inline-flex items-center text-blue-600 hover:text-blue-800 font-medium text-sm group">
          Read more
          <svg class="w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
          </svg>
        </a>
      </div>
    </article>
    {% endfor %}
  </div>
  {% else %}
  <!-- Empty State -->
  <div class="text-center py-12 bg-gray-50 rounded-lg">
    <svg class="w-16 h-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
    </svg>
    <p class="text-gray-600 text-lg">No posts yet. Start writing!</p>
  </div>
  {% endif %}
</div>

<!-- Optional: CTA Section -->
<div class="mt-16 bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg p-8 text-center text-white">
  <h3 class="text-2xl font-bold mb-4">Start Your Journey</h3>
  <p class="text-blue-100 mb-6">Explore more articles and tutorials on web development, design, and technology.</p>
  <a href="{{ get_url(path="@/blog/_index.md") }}" class="inline-block bg-white text-blue-600 px-6 py-3 rounded-lg font-semibold hover:bg-blue-50 transition">
    Browse All Posts
  </a>
</div>
{% endblock content %}
EOF

print_success "Updated index.html with grid layout"

# Create section template for blog list page
print_step "Creating blog section template..."

cat > templates/section.html <<'EOF'
{% extends "base.html" %}

{% block title %}{{ section.title }} | {{ config.title }}{% endblock title %}

{% block content %}
<!-- Blog Header -->
<div class="mb-12 text-center">
  <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">{{ section.title }}</h1>
  {% if section.content %}
  <div class="prose prose-lg mx-auto text-gray-600">
    {{ section.content | safe }}
  </div>
  {% endif %}
</div>

<!-- All Posts Grid -->
{% if section.pages %}
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
  {% for page in section.pages %}
  <article class="bg-white rounded-lg shadow-md hover:shadow-xl transition-all duration-300 overflow-hidden flex flex-col group">
    <!-- Gradient Header -->
    <div class="w-full h-48 bg-gradient-to-br from-blue-500 via-purple-500 to-pink-500 flex items-center justify-center relative overflow-hidden">
      <div class="absolute inset-0 bg-black opacity-0 group-hover:opacity-10 transition-opacity"></div>
      <span class="text-white text-7xl font-bold opacity-20">{{ page.title | truncate(length=1, end="") }}</span>
    </div>
    
    <!-- Card Content -->
    <div class="p-6 flex-1 flex flex-col">
      <!-- Date -->
      <time datetime="{{ page.date }}" class="text-xs font-semibold text-blue-600 uppercase tracking-wide mb-3">
        {{ page.date | date(format="%B %d, %Y") }}
      </time>
      
      <!-- Title -->
      <h2 class="text-xl font-bold text-gray-900 mb-3 group-hover:text-blue-600 transition">
        <a href="{{ page.permalink }}" class="hover:underline">{{ page.title }}</a>
      </h2>
      
      <!-- Description -->
      <p class="text-gray-600 text-sm mb-4 flex-1">
        {{ page.description | default(value="Click to read more...") }}
      </p>
      
      <!-- Tags -->
      {% if page.taxonomies.tags %}
      <div class="flex flex-wrap gap-2 mb-4">
        {% for tag in page.taxonomies.tags | slice(end=3) %}
        <span class="px-2 py-1 bg-gray-100 text-gray-700 text-xs rounded-full">{{ tag }}</span>
        {% endfor %}
      </div>
      {% endif %}
      
      <!-- Read More -->
      <a href="{{ page.permalink }}" class="inline-flex items-center text-blue-600 hover:text-blue-800 font-medium text-sm">
        Read full article
        <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
        </svg>
      </a>
    </div>
  </article>
  {% endfor %}
</div>
{% else %}
<!-- Empty State -->
<div class="text-center py-16 bg-gray-50 rounded-lg">
  <svg class="w-20 h-20 mx-auto text-gray-400 mb-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
  </svg>
  <h3 class="text-xl font-bold text-gray-900 mb-2">No posts yet</h3>
  <p class="text-gray-600">Check back soon for new content!</p>
</div>
{% endif %}
{% endblock content %}
EOF

print_success "Created section.html template"

# Add a couple more sample posts to showcase the grid
print_step "Adding sample posts..."

cat > content/blog/getting-started-with-zola.md <<'EOF'
+++
title = "Getting Started with Zola"
date = 2025-10-15
description = "Learn how to build blazing fast static sites with Zola, the Rust-powered static site generator."

[taxonomies]
tags = ["zola", "tutorial", "rust"]
+++

Zola is a fast static site generator written in Rust. In this post, we'll explore why Zola is an excellent choice for your next project.

## Why Zola?

- **Speed** - Built with Rust for maximum performance
- **Simple** - Easy configuration and straightforward templating
- **Flexible** - Powerful features without the complexity

Let's dive in!
EOF

cat > content/blog/mastering-tailwindcss.md <<'EOF'
+++
title = "Mastering TailwindCSS"
date = 2025-10-16
description = "Discover the power of utility-first CSS and learn how to build beautiful, responsive interfaces quickly."

[taxonomies]
tags = ["tailwindcss", "css", "design"]
+++

TailwindCSS has revolutionized the way we write CSS. Let's explore how utility-first CSS can speed up your development workflow.

## Key Benefits

1. **Rapid Development** - Build UIs faster with pre-built utilities
2. **Consistency** - Design system baked into your CSS
3. **Customization** - Easy to configure and extend

Ready to level up your styling?
EOF

print_success "Added sample posts"

# Test the build
print_step "Testing local build..."
make build > /dev/null 2>&1
print_success "Build successful"

echo ""
echo -e "${GREEN}✓ Homepage updated with grid layout!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Preview locally: ${GREEN}make serve${NC}"
echo "  2. Deploy to production: ${GREEN}make deploy${NC}"
echo ""
echo -e "${BLUE}What changed:${NC}"
echo "  ✓ Homepage now shows posts in a 3-column grid"
echo "  ✓ Cards have gradient headers and hover effects"
echo "  ✓ Added 'View all' link to blog page"
echo "  ✓ Created blog list page (section.html)"
echo "  ✓ Added 2 sample posts to showcase layout"
echo ""
echo -e "${BLUE}Responsive breakpoints:${NC}"
echo "  • Mobile: 1 column"
echo "  • Tablet: 2 columns"
echo "  • Desktop: 3 columns"
echo ""