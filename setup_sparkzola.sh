#!/bin/bash

# ==========================================
# SparkZola Quick Setup Script
# For Mac mini M1 | Zola 0.21.0 | Node 22.20.0
# Location: /Users/minijohn/Documents/github-repo/sparkzola
# ==========================================

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="/Users/minijohn/Documents/github-repo/sparkzola"
GITHUB_USER="yoloinfinity55"
REPO_NAME="sparkzola"
GITHUB_REPO="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

# ==========================================
# Helper Functions
# ==========================================

print_step() {
    echo -e "${BLUE}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# ==========================================
# Verification
# ==========================================

print_step "Verifying environment..."

# Check Zola
if ! command -v zola &> /dev/null; then
    print_error "Zola not found. Install with: brew install zola"
    exit 1
fi
print_success "Zola $(zola --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"

# Check Node
if ! command -v node &> /dev/null; then
    print_error "Node.js not found. Install via nvm or brew"
    exit 1
fi
print_success "Node $(node -v)"

# Check Git
if ! command -v git &> /dev/null; then
    print_error "Git not found"
    exit 1
fi
print_success "Git $(git --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"

echo ""

# ==========================================
# Project Setup
# ==========================================

print_step "Setting up SparkZola in ${PROJECT_DIR}..."

# Create project directory if it doesn't exist
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# ==========================================
# Initialize Zola
# ==========================================

print_step "Initializing Zola project..."

if [ ! -f "config.toml" ]; then
    # Create config.toml
    cat > config.toml <<'EOF'
base_url = "https://yoloinfinity55.github.io/sparkzola"
title = "SparkZola"
description = "A modern Zola + TailwindCSS blog"
compile_sass = false
build_search_index = true
theme = ""
output_dir = "public"
default_language = "en"

[markdown]
highlight_code = true
highlight_theme = "base16-ocean-dark"

[extra]
# Add custom variables here
EOF
    print_success "Created config.toml"
else
    print_warning "config.toml already exists, skipping"
fi

# Create directory structure
mkdir -p content/blog
mkdir -p templates
mkdir -p static/images
mkdir -p sass

# ==========================================
# Initialize Node + TailwindCSS
# ==========================================

print_step "Setting up Node.js and TailwindCSS..."

# Initialize package.json
if [ ! -f "package.json" ]; then
    npm init -y > /dev/null 2>&1
    print_success "Created package.json"
fi

# Install TailwindCSS
print_step "Installing TailwindCSS dependencies..."
npm install -D tailwindcss postcss autoprefixer > /dev/null 2>&1
print_success "TailwindCSS installed"

# Initialize Tailwind config
if [ ! -f "tailwind.config.js" ]; then
    npx tailwindcss init > /dev/null 2>&1
fi

# Update Tailwind config
cat > tailwind.config.js <<'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./templates/**/*.html",
    "./content/**/*.md"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF
print_success "Configured tailwind.config.js"

# Create input.css
cat > input.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Custom styles */
@layer components {
  .prose {
    @apply text-gray-800 leading-relaxed;
  }
  
  .prose h1 {
    @apply text-4xl font-bold mb-4;
  }
  
  .prose h2 {
    @apply text-3xl font-bold mb-3 mt-8;
  }
  
  .prose p {
    @apply mb-4;
  }
  
  .prose a {
    @apply text-blue-600 hover:text-blue-800 underline;
  }
}
EOF
print_success "Created input.css"

# Update package.json scripts
npm pkg set scripts.build:css="npx tailwindcss -i ./input.css -o ./static/style.css --minify"
npm pkg set scripts.watch:css="npx tailwindcss -i ./input.css -o ./static/style.css --watch"
npm pkg set scripts.build="npm run build:css && zola build"
npm pkg set scripts.serve="npm run build:css && zola serve"
print_success "Added npm scripts"

# ==========================================
# Create Content
# ==========================================

print_step "Creating sample content..."

# Create home page
cat > content/_index.md <<'EOF'
+++
title = "SparkZola"
description = "A modern static blog built with Zola and TailwindCSS"
+++

# Welcome to SparkZola

This is a modern, fast, and minimalist blog built with:
- **Zola** - A blazing fast static site generator
- **TailwindCSS** - A utility-first CSS framework
- **GitHub Pages** - Free hosting for your static site

Check out the [blog](/blog) to see posts in action.
EOF
print_success "Created home page"

# Create blog index
cat > content/blog/_index.md <<'EOF'
+++
title = "Blog"
sort_by = "date"
template = "blog.html"
page_template = "blog-page.html"
+++

# Blog Posts

Welcome to the SparkZola blog!
EOF
print_success "Created blog index"

# Create sample post
cat > content/blog/hello-sparkzola.md <<'EOF'
+++
title = "Hello SparkZola"
date = 2025-10-14
description = "Welcome to SparkZola - a modern static blog built with Zola and TailwindCSS"

[taxonomies]
tags = ["zola", "tailwindcss", "static-site"]
+++

Welcome to **SparkZola**! This is your first blog post.

## What is SparkZola?

SparkZola is a modern static blog built with:

- **Zola**: A fast static site generator written in Rust
- **TailwindCSS**: A utility-first CSS framework for rapid UI development
- **GitHub Pages**: Free hosting for static websites

## Why Static Sites?

Static sites offer several advantages:

1. **Fast**: No database queries or server-side processing
2. **Secure**: No server-side code means fewer attack vectors
3. **Scalable**: Easy to serve from CDNs
4. **Simple**: Easy to version control and deploy

## Getting Started

To create your own posts, simply add Markdown files to the `content/blog/` directory with proper front matter.

Happy blogging! 🚀
EOF
print_success "Created sample blog post"

# ==========================================
# Create Templates
# ==========================================

print_step "Creating templates..."

# Base template
cat > templates/base.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{% block title %}{{ config.title }}{% endblock title %}</title>
  <meta name="description" content="{% block description %}{{ config.description }}{% endblock description %}">
  <link rel="stylesheet" href="{{ get_url(path="style.css") }}">
</head>
<body class="bg-gray-50 text-gray-900 font-sans">
  <!-- Header -->
  <header class="bg-white shadow-sm border-b border-gray-200">
    <nav class="max-w-4xl mx-auto px-6 py-4 flex justify-between items-center">
      <a href="{{ config.base_url }}" class="text-2xl font-bold text-gray-900 hover:text-blue-600 transition">
        {{ config.title }}
      </a>
      <div class="space-x-6">
        <a href="{{ config.base_url }}" class="text-gray-600 hover:text-blue-600 transition">Home</a>
        <a href="{{ get_url(path="@/blog/_index.md") }}" class="text-gray-600 hover:text-blue-600 transition">Blog</a>
      </div>
    </nav>
  </header>

  <!-- Main Content -->
  <main class="max-w-4xl mx-auto px-6 py-12">
    {% block content %}{% endblock content %}
  </main>

  <!-- Footer -->
  <footer class="border-t border-gray-200 mt-16 py-8">
    <div class="max-w-4xl mx-auto px-6 text-center text-sm text-gray-500">
      <p>© {{ now() | date(format="%Y") }} {{ config.title }}. Built with <a href="https://www.getzola.org" class="text-blue-600 hover:underline">Zola</a> and <a href="https://tailwindcss.com" class="text-blue-600 hover:underline">TailwindCSS</a>.</p>
    </div>
  </footer>
</body>
</html>
EOF
print_success "Created base.html"

# Index template
cat > templates/index.html <<'EOF'
{% extends "base.html" %}

{% block content %}
<div class="prose max-w-none">
  {{ section.content | safe }}
</div>

<div class="mt-12">
  <h2 class="text-2xl font-bold mb-6">Recent Posts</h2>
  <div class="space-y-6">
    {% set blog = get_section(path="blog/_index.md") %}
    {% for page in blog.pages | slice(end=5) %}
    <article class="bg-white p-6 rounded-lg shadow hover:shadow-md transition">
      <h3 class="text-xl font-bold mb-2">
        <a href="{{ page.permalink }}" class="text-gray-900 hover:text-blue-600">{{ page.title }}</a>
      </h3>
      <p class="text-gray-600 text-sm mb-3">{{ page.date | date(format="%B %d, %Y") }}</p>
      <p class="text-gray-700">{{ page.description }}</p>
      <a href="{{ page.permalink }}" class="inline-block mt-4 text-blue-600 hover:underline">Read more →</a>
    </article>
    {% endfor %}
  </div>
</div>
{% endblock content %}
EOF
print_success "Created index.html"

# Blog page template
cat > templates/blog-page.html <<'EOF'
{% extends "base.html" %}

{% block title %}{{ page.title }} | {{ config.title }}{% endblock title %}
{% block description %}{{ page.description }}{% endblock description %}

{% block content %}
<article>
  <header class="mb-8">
    <h1 class="text-4xl font-bold text-gray-900 mb-4">{{ page.title }}</h1>
    <div class="text-gray-600 text-sm">
      <time datetime="{{ page.date }}">{{ page.date | date(format="%B %d, %Y") }}</time>
    </div>
  </header>

  <div class="prose prose-lg max-w-none">
    {{ page.content | safe }}
  </div>

  {% if page.taxonomies.tags %}
  <div class="mt-12 pt-6 border-t border-gray-200">
    <div class="flex flex-wrap gap-2">
      {% for tag in page.taxonomies.tags %}
      <span class="px-3 py-1 bg-blue-100 text-blue-800 text-sm rounded-full">{{ tag }}</span>
      {% endfor %}
    </div>
  </div>
  {% endif %}
</article>
{% endblock content %}
EOF
print_success "Created blog-page.html"

# ==========================================
# Create GitHub Actions Workflow
# ==========================================

print_step "Setting up GitHub Actions..."

mkdir -p .github/workflows

cat > .github/workflows/deploy.yml <<'EOF'
name: Deploy SparkZola to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build TailwindCSS
        run: npm run build:css

      - name: Setup Zola
        uses: taiki-e/install-action@v2
        with:
          tool: zola@0.21.0

      - name: Build Zola site
        run: zola build

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOF
print_success "Created GitHub Actions workflow"

# ==========================================
# Create .gitignore
# ==========================================

cat > .gitignore <<'EOF'
# Build output
public/
*.log

# Dependencies
node_modules/
package-lock.json

# OS files
.DS_Store
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~

# Generated CSS (tracked in git for simplicity)
# static/style.css
EOF
print_success "Created .gitignore"

# ==========================================
# Create Makefile
# ==========================================

print_step "Creating Makefile..."

cat > Makefile <<'EOF'
# ==========================================
# SparkZola Makefile
# ==========================================

PROJECT_NAME = sparkzola
GITHUB_USER  = yoloinfinity55
GITHUB_REPO  = https://github.com/$(GITHUB_USER)/$(PROJECT_NAME).git
BUILD_DIR    = public

.PHONY: help setup css build serve deploy clean status

default: help

help:
	@echo ""
	@echo "SparkZola Project Commands:"
	@echo "  make setup       → Install dependencies"
	@echo "  make css         → Build TailwindCSS"
	@echo "  make build       → Build complete site"
	@echo "  make serve       → Run local dev server"
	@echo "  make deploy      → Build and push to GitHub"
	@echo "  make clean       → Remove build artifacts"
	@echo "  make status      → Show git status"
	@echo ""

setup:
	@echo "🧩 Installing dependencies..."
	@npm install
	@echo "✓ Setup complete"

css:
	@echo "🎨 Building TailwindCSS..."
	@npm run build:css
	@echo "✓ CSS built"

build: css
	@echo "🏗️  Building Zola site..."
	@zola build
	@echo "✓ Site built in ./public"

serve: css
	@echo "🚀 Starting dev server at http://127.0.0.1:1111"
	@zola serve

deploy: build
	@echo "📦 Deploying to GitHub..."
	@git add .
	@git commit -m "Update site: $$(date +'%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
	@git push origin main
	@echo "✓ Pushed to GitHub. Actions will deploy to Pages."

clean:
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "✓ Cleaned"

status:
	@echo "📡 Git status:"
	@git status
	@echo ""
	@git remote -v
EOF
print_success "Created Makefile"

# ==========================================
# Create README
# ==========================================

cat > README.md <<'EOF'
# SparkZola

A modern, fast static blog built with Zola and TailwindCSS.

## Features

- ⚡️ **Fast**: Built with Zola (Rust-based SSG)
- 🎨 **Modern**: Styled with TailwindCSS
- 📱 **Responsive**: Mobile-first design
- 🚀 **Automated**: GitHub Actions deployment
- 🆓 **Free**: Hosted on GitHub Pages

## Quick Start

```bash
# Install dependencies
make setup

# Start local server
make serve

# Build site
make build

# Deploy to GitHub Pages
make deploy
```

## Development

- **Local URL**: http://127.0.0.1:1111
- **Build time**: ~2-5 seconds
- **Live reload**: Enabled by default

## Project Structure

```
sparkzola/
├── content/          # Markdown content
├── templates/        # HTML templates
├── static/           # Static assets
├── config.toml       # Zola configuration
└── Makefile          # Build automation
```

## Commands

| Command | Description |
|---------|-------------|
| `make serve` | Start dev server |
| `make build` | Build site |
| `make deploy` | Deploy to GitHub |
| `make clean` | Clean build files |

## Tech Stack

- [Zola](https://www.getzola.org/) - Static site generator
- [TailwindCSS](https://tailwindcss.com/) - CSS framework
- [GitHub Pages](https://pages.github.com/) - Hosting
- [GitHub Actions](https://github.com/features/actions) - CI/CD

## License

MIT
EOF
print_success "Created README.md"

# ==========================================
# Build Initial CSS
# ==========================================

print_step "Building initial CSS..."
npm run build:css > /dev/null 2>&1
print_success "CSS built successfully"

# ==========================================
# Git Initialization
# ==========================================

print_step "Initializing Git repository..."

if [ ! -d ".git" ]; then
    git init
    git branch -M main
    print_success "Git repository initialized"
else
    print_warning "Git repository already exists"
fi

# Check if remote exists
if ! git remote | grep -q "origin"; then
    git remote add origin "$GITHUB_REPO"
    print_success "Added remote: $GITHUB_REPO"
else
    print_warning "Remote 'origin' already exists"
fi

# ==========================================
# Final Steps
# ==========================================

echo ""
print_success "SparkZola setup complete!"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Review the generated files"
echo "  2. Test locally:  ${GREEN}make serve${NC}"
echo "  3. Create GitHub repo: ${YELLOW}https://github.com/new${NC}"
echo "  4. Push to GitHub: ${GREEN}git add . && git commit -m 'Initial commit' && git push -u origin main${NC}"
echo "  5. Enable GitHub Pages in repo settings"
echo ""
echo -e "${BLUE}Your site will be live at:${NC}"
echo "  ${GREEN}https://${GITHUB_USER}.github.io/${REPO_NAME}${NC}"
echo ""
echo -e "${YELLOW}Pro tip:${NC} Run 'make help' to see all available commands"
echo ""