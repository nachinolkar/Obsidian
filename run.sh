#!/bin/bash

pip install python-slugify

# Avoid copying over netlify.toml (will ebe exposed to public API)
echo "netlify.toml" >>.gitignore

# Sync Zola template contents

# Remove previous build and sync Zola template contents
rm -rf build
rsync -vaP __site/zola/ __site/build
rsync -vaP __site/zola/content/ __site/build/content

# Use obsidian-export to export markdown content from obsidian
mkdir -pv __site/build/content/docs 
mkdir -pv __site/build/docs
#__site/build/__docs

chmod a+x __site/bin/obsidian-export

if [ -z "$STRICT_LINE_BREAKS" ]; then
	echo "this loop here"
	__site/bin/obsidian-export --frontmatter=never --hard-linebreaks --no-recursive-embeds MyThoughts __site/build/docs
else
	echo "that loop there"
	__site/bin/obsidian-export --frontmatter=never --no-recursive-embeds MyThoughts __site/build/docs
fi

ls -R __site/build/docs
echo "obsidian export?"

# Run conversion script
python __site/convert.py

# Build Zola site
zola --root __site/build build --output-dir public
