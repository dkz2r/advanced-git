#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

usage() {
  echo "Usage: $0 -r REPO [-h]"
  echo "  -r REPO   The repository to create a new repository in (format: owner/repo)"
  echo "  -h        Show this help message"
  exit 1
}

repo=""
while getopts ":r:h" opt; do
  case "$opt" in
    r) repo="$OPTARG" ;;
    h) usage ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage ;;
    :) echo "Option -$OPTARG requires an argument." >&2; usage ;;
  esac
done

echo "Creating and pushing content to'$repo'..."

# Create a temporary directory for us to add content to
dir_name="$(mktemp -d)"
mkdir -p "$dir_name"

# Move to the newly created directory and initialize a git repository
cd "$dir_name"
git init

# Create a README file
cat > README.md <<README_EOF
# README

This repository is created to demonstrate how to work with a repository in git.

It is based off of a woodworking project collection, and contains commits and branches intended to provide
interactive practice for various git techniques.

## Elements
- A branch for practicing cherry-picking (\`marias-projects\`)
- Multiple commits modifying the same file, incorporating a mistake to be fixed via interactive rebase (\`bookshelf-project\`)
README_EOF

# Create some files for content
cat > tool-box.md <<TOOLBOX_EOF
# Basic Tool Box
## Materials
* pine wood (2x4, 3 feet)
* wood screws (12)
* wood glue (4 oz)
## Steps
* cut wood to size
* assemble sides
* attach bottom
TOOLBOX_EOF

cat > cutting-board.md <<CUTTINGBOARD_EOF
# Cutting Board
## Materials
* hardwood (walnut, 12x8 inches)
* mineral oil (2 oz)
## Steps
* sand wood smooth
* apply mineral oil
CUTTINGBOARD_EOF

cat > picture-frame.md <<PICTUREFRAME_EOF
# Picture Frame
## Materials
* oak trim (4 pieces, 8 inches each)
* glass pane (6x8 inches)
* wood glue (1 oz)
* small nails (8)
## Steps
PICTUREFRAME_EOF

mkdir furniture

cat > furniture/coffee-table.md <<COFFEETABLE_EOF
# Coffee Table
## Materials
## Steps
COFFEETABLE_EOF

mkdir shelves

cat > shelves/wall-shelf.md <<WALLSHELF_EOF
# Wall Shelf
## Materials
* pine board (1x6, 24 inches)
## Steps
WALLSHELF_EOF

cat > shelves/bookshelf.md <<BOOKSHELF_EOF
# Bookshelf
## Materials
## Steps
BOOKSHELF_EOF

# Stage and commit the files
git add .
git commit -m "Initial commit with woodworking project files"

# Add the remote repository
git remote add origin "$repo"
# Push the content to the remote repository
git branch -M main
git push -u origin main --force

# Make a branch off of main to use for cherrypicking practice
git checkout -b marias-projects
cat > furniture/coffee-table.md <<COFFEETABLE_EOF
# Maria's Coffee Table
## Materials
- oak plywood (4x2 feet)
- table legs (4, 16 inches)
- wood screws (20)
- wood stain (8 oz, dark walnut)
- polyurethane (8 oz)
## Steps
COFFEETABLE_EOF
git add furniture/coffee-table.md
git commit -m "Update coffee table project to Maria's version"

cat > shelves/wall-shelf.md <<WALLSHELF_EOF
# Maria's Wall Shelf
## Materials
* pine board (1x6, 24 inches)
* shelf brackets (2)
* wood stain (4 oz, cherry)
## Steps
WALLSHELF_EOF
git add shelves/wall-shelf.md
git commit -m "Update wall shelf project to Maria's version"

git push -u origin marias-projects --force

git checkout main

# Make multiple commits modifying the same file to allow for interactive rebase practice
git checkout -b shelf-projects

cat > shelves/wall-shelf.md <<WALLSHELF_EOF
# Wall Shelf
## Materials
- pine board (1x6, 24 inches)
- shelf brackets (2)
- wood screws (6)
## Steps
- Cut board to desired length.
- Sand all edges smooth.
WALLSHELF_EOF
git add shelves/wall-shelf.md
git commit -m "Add Wall Shelf project details"

cat > shelves/bookshelf.md <<BOOKSHELF_EOF
# Bookshelf
## Materials
- plywood sheets (3, 4x8 feet)
- wood screws (40)
- wood gleu (8 oz)
- sandpaper (120 grit)
- shelf pins (12)
## Steps
BOOKSHELF_EOF
git add shelves/bookshelf.md
git commit -m "Add Bookshelf project with materials"

sed -i 's/wood gleu/wood glue/' shelves/bookshelf.md
git add shelves/bookshelf.md
git commit -m "Fix typo in materials"

echo "- Cut plywood to dimensions (36x12 inches for shelves, 36x36 for sides)." >> shelves/bookshelf.md
echo "- Sand all pieces with 120 grit sandpaper." >> shelves/bookshelf.md
echo "- Assemble frame with wood glue and screws." >> shelves/bookshelf.md
git add shelves/bookshelf.md
git commit -m "Additional steps for bookshelf project"

echo "- Drill holes for adjustable shelf pins (every 2 inches)." >> shelves/bookshelf.md
git add shelves/bookshelf.md
git commit -m "Complete bookshelf project instructions"

git push -u origin shelf-projects --force

# Return to main branch
git checkout main

# Add more changes to main to ensure shelf-projects is behind main
cat > picture-frame.md <<PICTUREFRAME_EOF
# Picture Frame
## Materials
* oak trim (4 pieces, 8 inches each)
* glass pane (6x8 inches)
* wood glue (2 oz)
* small nails (8)
## Steps
* miter cut all pieces at 45 degrees and assemble
PICTUREFRAME_EOF

git add picture-frame.md
git commit -m "Update picture frame project with correct glue amount"

cat > shelves/bookshelf.md <<BOOKSHELF_EOF
# Bookshelf
NOTE: Ask Tom for his bookshelf design
## Materials
## Steps
BOOKSHELF_EOF

git add shelves/bookshelf.md
git commit -m "Add note to ask Tom for his bookshelf design"

git push -u origin main --force

echo "Content pushed to '$repo' successfully."

# Clean up the temporary directory
cd ..
rm -rf "$dir_name"

echo "Temporary directory cleaned up."
echo "Done."

# git fetch origin --prune && git reset --hard origin/main && git clean -fd && git branch | grep -v "main" | xargs git branch -D 2>/dev/null; git branch -r | grep -v '\->' | sed 's/origin\///' | grep -v "main" | xargs -I {} git checkout --track origin/{} && git checkout main
