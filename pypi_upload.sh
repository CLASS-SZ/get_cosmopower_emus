#!/bin/bash

# Ensure to manually update the version number in setup.py before running this script

# Function to increment version
increment_version() {
  current_version=$(grep -Eo 'version = "[^"]*' pyproject.toml | cut -d'"' -f2)
  IFS='.' read -r -a version_parts <<< "$current_version"

  major=${version_parts[0]}
  minor=${version_parts[1]}
  patch=${version_parts[2]}

  patch=$((patch + 1))
  if [ $patch -ge 100 ]; then
    patch=0
    minor=$((minor + 1))
  fi
  if [ $minor -ge 100 ]; then
    minor=0
    major=$((major + 1))
  fi

  new_version="$major.$minor.$patch"

  # Update the pyproject.toml with the new version
  sed -i '' "s/version = \"$current_version\"/version = \"$new_version\"/" pyproject.toml
}

# Increment the version
increment_version


# Remove old build files
rm -rf build dist *.egg-info

# Build the package using `build`
python -m build

# Upload the package
twine upload dist/*

# Clean up build directories
rm -rf build dist *.egg-info