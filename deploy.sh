#!/bin/bash

# Debt Freedom Calculator Deployment Script
# Supports: Netlify, Vercel, GitHub Pages, AWS S3, Firebase

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🎯 Debt Freedom Calculator - Deployment Script${NC}"
echo ""

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
    echo -e "${RED}Error: index.html not found. Please run this script from the debt-freedom-calculator directory.${NC}"
    exit 1
fi

# Function to deploy to Netlify
deploy_netlify() {
    echo -e "${YELLOW}Deploying to Netlify...${NC}"
    
    if ! command -v netlify &> /dev/null; then
        echo "Installing Netlify CLI..."
        npm install -g netlify-cli
    fi
    
    if [ ! -f ".netlify/state.json" ]; then
        echo "Initializing Netlify site..."
        netlify init
    else
        echo "Deploying to existing site..."
        netlify deploy --prod --dir=.
    fi
    
    echo -e "${GREEN}✅ Deployed to Netlify!${NC}"
}

# Function to deploy to Vercel
deploy_vercel() {
    echo -e "${YELLOW}Deploying to Vercel...${NC}"
    
    if ! command -v vercel &> /dev/null; then
        echo "Installing Vercel CLI..."
        npm install -g vercel
    fi
    
    vercel --prod
    
    echo -e "${GREEN}✅ Deployed to Vercel!${NC}"
}

# Function to deploy to GitHub Pages
deploy_github() {
    echo -e "${YELLOW}Deploying to GitHub Pages...${NC}"
    
    if [ ! -d ".git" ]; then
        echo -e "${RED}Error: Not a git repository. Please initialize first.${NC}"
        exit 1
    fi
    
    # Create gh-pages branch if it doesn't exist
    if ! git show-ref --verify --quiet refs/heads/gh-pages; then
        git checkout --orphan gh-pages
        git rm -rf .
        git checkout main -- .
        git add .
        git commit -m "Initial GitHub Pages deployment"
        git push origin gh-pages
        git checkout main
    else
        git subtree push --prefix . origin gh-pages
    fi
    
    echo -e "${GREEN}✅ Deployed to GitHub Pages!${NC}"
    echo "Your site will be available at: https://[username].github.io/[repo-name]/"
}

# Function to deploy to AWS S3
deploy_aws() {
    echo -e "${YELLOW}Deploying to AWS S3...${NC}"
    
    if ! command -v aws &> /dev/null; then
        echo -e "${RED}Error: AWS CLI not installed.${NC}"
        exit 1
    fi
    
    read -p "Enter your S3 bucket name: " BUCKET_NAME
    read -p "Enter AWS region (default: us-east-1): " REGION
    REGION=${REGION:-us-east-1}
    
    aws s3 sync . s3://$BUCKET_NAME --exclude "*.sh" --exclude ".git/*" --exclude "node_modules/*"
    
    echo -e "${GREEN}✅ Deployed to S3!${NC}"
    echo "Bucket URL: http://$BUCKET_NAME.s3-website-$REGION.amazonaws.com"
}

# Function to deploy to Firebase
deploy_firebase() {
    echo -e "${YELLOW}Deploying to Firebase...${NC}"
    
    if ! command -v firebase &> /dev/null; then
        echo "Installing Firebase CLI..."
        npm install -g firebase-tools
    fi
    
    if [ ! -f "firebase.json" ]; then
        firebase init hosting
    fi
    
    firebase deploy
    
    echo -e "${GREEN}✅ Deployed to Firebase!${NC}"
}

# Menu
echo "Select deployment target:"
echo "1) Netlify (Recommended - Free CDN + HTTPS)"
echo "2) Vercel (Free + Analytics)"
echo "3) GitHub Pages (Free, integrated with git)"
echo "4) AWS S3 (Scalable, pay per use)"
echo "5) Firebase (Google infrastructure)"
echo "6) Local preview only"
echo ""
read -p "Enter choice [1-6]: " choice

case $choice in
    1)
        deploy_netlify
        ;;
    2)
        deploy_vercel
        ;;
    3)
        deploy_github
        ;;
    4)
        deploy_aws
        ;;
    5)
        deploy_firebase
        ;;
    6)
        echo -e "${YELLOW}Starting local server...${NC}"
        python -m http.server 8000
        echo "Open http://localhost:8000"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac
