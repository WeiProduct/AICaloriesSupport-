# GitHub Pages Support Website Deployment Guide

## 🚀 Quick Setup Instructions

I've created a complete support website for your AI Calorie app. Here's how to deploy it:

### Step 1: Create GitHub Repository

1. Go to [GitHub.com](https://github.com) and sign in
2. Click the **"+"** icon (top right) → **"New repository"**
3. Repository settings:
   - **Name:** `ai-calories-support`
   - **Visibility:** Public (required for free GitHub Pages)
   - **DON'T** initialize with README
4. Click **"Create repository"**

### Step 2: Push the Support Website

Open Terminal and run these commands:

```bash
# Navigate to your project
cd /Users/weifu/Desktop/AI卡路里

# Initialize git for the docs folder
cd docs
git init

# Add all files
git add .

# Commit
git commit -m "Initial support website for AI Calorie app"

# Add your repository (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/ai-calories-support.git

# Push to GitHub
git push -u origin main
```

### Step 3: Enable GitHub Pages

1. Go to your repository: `https://github.com/YOUR_USERNAME/ai-calories-support`
2. Click **"Settings"** tab
3. Scroll to **"Pages"** section (left sidebar)
4. Configure:
   - **Source:** Deploy from a branch
   - **Branch:** main
   - **Folder:** / (root)
5. Click **"Save"**

### Step 4: Wait for Deployment

- GitHub will show a message: "Your site is live at..."
- Takes 2-10 minutes for first deployment
- URL will be: `https://YOUR_USERNAME.github.io/ai-calories-support/`

### Step 5: Add App Icon

1. Save your app icon as `app-icon.png` (recommended: 512x512px)
2. Add it to the repository:
```bash
# Copy your app icon to the docs folder
cp /path/to/your/app-icon.png app-icon.png

# Add and commit
git add app-icon.png
git commit -m "Add app icon"
git push
```

### Step 6: Update App Store Connect

1. Go to App Store Connect
2. Navigate to your app
3. Update the **Support URL** to: `https://YOUR_USERNAME.github.io/ai-calories-support/`
4. Save changes

## 📝 What's Included

Your support website includes:

- ✅ **Bilingual Support** (English & Chinese)
- ✅ **Contact Methods**:
  - Email support
  - Bug reporting via GitHub Issues
  - Feature requests
- ✅ **Comprehensive FAQ**
- ✅ **Privacy Policy**
- ✅ **Terms of Service**
- ✅ **Issue Templates** for organized feedback

## 🎨 Customization

### Update Contact Email
Replace `support@aicalorie.app` with your actual email in:
- `index.html`
- `index-zh.html`

### Change Colors
The main color is green (#4CAF50). To change it, search and replace in all HTML files.

### Add More FAQs
Edit the FAQ section in `index.html` and `index-zh.html`

## 🔧 Troubleshooting

### Pages not showing?
- Check Settings → Pages to see build status
- Ensure repository is Public
- Clear browser cache

### 404 Error?
- Wait 10 minutes after enabling Pages
- Check the URL is correct
- Ensure files are in the root of repository

## 📱 Reply to Apple

Once deployed, respond to Apple:

```
Thank you for your feedback. We have created a comprehensive support website that provides users with multiple ways to get help and support.

Support URL: https://YOUR_USERNAME.github.io/ai-calories-support/

The support website includes:
- Multiple contact methods (email support, bug reporting, feature requests)
- Detailed FAQ section in both English and Chinese
- Privacy Policy and Terms of Service
- GitHub Issues integration for systematic feedback collection
- Responsive design for both desktop and mobile users

Users can easily find answers to common questions, report issues, and contact our support team directly from the website.
```

## ✅ Final Checklist

- [ ] Repository created and set to Public
- [ ] All files pushed to GitHub
- [ ] GitHub Pages enabled
- [ ] Website accessible via browser
- [ ] App icon displayed correctly
- [ ] Email addresses updated
- [ ] App Store Connect updated with new URL

Your support website is now ready! 🎉