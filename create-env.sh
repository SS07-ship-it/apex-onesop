#!/bin/bash
# Run this once to create your local .env file
# Replace YOUR-API-KEY with your actual Anthropic API key

cd ~/Downloads/apex-onestop

echo "Enter your Anthropic API key (starts with sk-ant-):"
read -s API_KEY

echo "ANTHROPIC_API_KEY=$API_KEY" > .env
echo "✅ .env file created"
echo "Now run: netlify dev"
