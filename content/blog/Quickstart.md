+++
title = "SparkZola Quick Start Guide"
date = 2025-10-15
description = "A practical reference with: ✅ One-time setup steps ✅ Daily workflow ✅ Essential commands ✅ Quick customizations ✅ Troubleshooting tips ✅ Pro tips"
+++

# SparkZola Quick Start Guide

## 🚀 One-Time Setup

### 1. Run the Setup Script
```bash
cd /Users/minijohn/Documents/github-repo/sparkzola
chmod +x setup_sparkzola_final.sh
./setup_sparkzola_final.sh
```

### 2. Test Locally
```bash
make serve
# Visit http://127.0.0.1:1111
```

### 3. Create GitHub Repository
1. Go to https://github.com/new
2. Name: `sparkzola`
3. Visibility: **Public**
4. **Don't initialize** with README
5. Click "Create repository"

### 4. Push to GitHub
```bash
git add .
git commit -m "Initial SparkZola setup"
git push -u origin main
```

### 5. Enable GitHub Pages
1. Go to repo Settings → Pages
2. Source: **GitHub Actions**
3. Wait 2-3 minutes

### 6. Visit Your Live Site
**https://yoloinfinity55.github.io/sparkzola**

---

## 📝 Daily Workflow

### Create a New Post
```bash
cat > content/blog/my-new-post.md <<'EOF'
+++
title = "My Post Title"
date = 2025-10-15
description = "Brief description"
+++

Your content here...
EOF
```

### Preview Locally
```bash
make serve
# Visit http://127.0.0.1:1111
# Changes auto-reload!
```

### Deploy to Production
```bash
make deploy
# Automatically: builds, commits, pushes
# GitHub Actions deploys in 2-3 minutes
```

---

## 🎯 Essential Commands

| Command | What It Does |
|---------|--------------|
| `make serve` | Start local dev server |
| `make build` | Build production site |
| `make deploy` | Deploy to GitHub Pages |
| `make clean` | Remove build files |
| `make status` | Check git status |
| `make help` | Show all commands |

---

## 📁 Key Files

| File | Purpose |
|------|---------|
| `config.toml` | Site configuration (title, URL, etc.) |
| `content/blog/*.md` | Your blog posts |
| `templates/base.html` | Site layout (header, footer) |
| `tailwind.config.js` | CSS customization |
| `Makefile` | Build automation |

---

## 🎨 Quick Customizations

### Change Site Title
```bash
# Edit config.toml
title = "Your New Title"
description = "Your description"
```

### Add Navigation Link
```bash
# Edit templates/base.html
<a href="/about" class="...">About</a>
```

### Customize Colors
```bash
# Edit tailwind.config.js
theme: {
  extend: {
    colors: {
      primary: '#your-color',
    }
  }
}
```

---

## 🐛 Troubleshooting

### Site not updating locally?
```bash
make clean
make serve
```

### CSS not applying?
```bash
npm run build:css
make serve
```

### GitHub Actions failing?
1. Check: https://github.com/yoloinfinity55/sparkzola/actions
2. Verify `package.json` has scripts defined
3. Ensure `tailwindcss@3.4.1` is installed

### 404 on GitHub Pages?
1. Repo must be **Public**
2. Settings → Pages → Source: **GitHub Actions**
3. Wait 2-3 minutes after first push
4. Check `base_url` in `config.toml`

---

## 📚 Post Front Matter Reference

```markdown
+++
title = "Post Title"              # Required
date = 2025-10-15                 # Required (YYYY-MM-DD)
description = "SEO description"   # Optional but recommended

[taxonomies]
tags = ["tag1", "tag2"]          # Optional
+++
```

---

## 🔗 Important URLs

- **Local Dev:** http://127.0.0.1:1111
- **Live Site:** https://yoloinfinity55.github.io/sparkzola
- **Repository:** https://github.com/yoloinfinity55/sparkzola
- **Actions:** https://github.com/yoloinfinity55/sparkzola/actions

---

## 💡 Pro Tips

1. **Keep `make serve` running** while editing - auto-reloads!
2. **Use `make deploy`** instead of manual git commands
3. **Check Actions tab** on GitHub if deployment fails
4. **Write in Markdown** - it's easy and powerful
5. **Commit often** - Git is your safety net

---

## 📖 Learning Resources

- **Zola Docs:** https://www.getzola.org/documentation/
- **TailwindCSS:** https://tailwindcss.com/docs
- **Markdown Guide:** https://www.markdownguide.org/

---

## ✅ Checklist for New Posts

- [ ] Create `.md` file in `content/blog/`
- [ ] Add front matter (title, date, description)
- [ ] Write content in Markdown
- [ ] Test locally: `make serve`
- [ ] Deploy: `make deploy`
- [ ] Verify live site in 2-3 minutes

---

**Happy blogging! 🚀**