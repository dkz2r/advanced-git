# variables
WORKING_DIR    ?= ../
REPO_NAME      ?= recipes
REMOTE_REPO    ?=
UPSTREAM_REPO  ?=
REPO_PATH      := $(WORKING_DIR)/$(REPO_NAME)
FORKING_REPO   ?=


.PHONY: reset init-repo init-basic-repo git-basic-03-create git-basic-04-tracking-changes git-basic-06-ignore git-basic-08-collab git-basic-09-conflict git-adv-01-introduction git-adv-02-branching git-adv-02-branching-challenge-01 git-adv-02-branching-challenge-02 git-adv-02-branching-challenge-03 git-adv-03-remote git-adv-03-remote-challenge-01 git-adv-03-remote-challenge-02 git-adv-04-undo git-adv-04-undo-exercise-01 git-adv-05-merging git-adv-05-merging-exercise-01 git-adv-06-tags git-adv-06-tags-exercise-01 git-adv-09-forking git-adv-12-large-files git-adv-13-cherrypick git-adv-13-cherrypick-exercise-01 git-adv-13-cherrypick-exercise-02 git-adv-13-cherrypick-exercise-upstream git-adv-13-cherrypick-exercise-undoing-commits git-adv-14-squash-rebase git-adv-14-squash-rebase-exercise-01 git-adv-14-squash-rebase-exercise-02 git-adv-15-hooks-actions git-adv-15-hooks-actions-challenge-01


.ONESHELL:

reset:
	echo "Resetting $(REPO_PATH) to a clean state..."
	rm -rf $(REPO_PATH)

init-repo:
	git config --local user.name "Example User"
	git config --local user.email "example@email.com"

# --- Basic Git Workshop ---
git-basic-03-create: init-repo
	mkdir -p $(REPO_PATH)
	cd $(REPO_PATH)
	git init -b main

git-basic-04-tracking-changes: git-basic-03-create
	cd $(REPO_PATH)
	git tag git-basic-04-tracking-changes
	printf '%s\n' "# Guacamole" "## Ingredients" "## Instructions" > guacamole.md
	git add guacamole.md
	git commit -m "Create initial structure for a Guacamole recipe"
	printf '%s\n' "# Guacamole" "## Ingredients" "* avocado" "* lemon" "* salt" "## Instructions" > guacamole.md
	git add guacamole.md
	git commit -m "Add ingredients for basic guacamole"
	printf '%s\n' "# Guacamole" "## Ingredients" "* avocado" "* lime" "* salt" "## Instructions" > guacamole.md
	git add guacamole.md
	git commit -m "Modify guacamole to the traditional recipe"
	mkdir -p cakes
	touch cakes/brownie cakes/lemon_drizzle
	git add cakes
	git commit -m "Add some initial cakes"
	printf '%s\n' "# Guacamole" "## Ingredients" "* avocado (1.35)" "* lime (0.64)" "* salt (2)" "## Instructions" > guacamole.md
	printf '%s\n' "# Market A" "* avocado: 1.35 per unit." "* lime: 0.64 per unit." "* salt: 2 per unit." > groceries.md
	git add guacamole.md groceries.md
	git commit -m "Write prices for ingredients and their source"

git-basic-05-exploring-history: git-basic-04-tracking-changes
	cd $(REPO_PATH)
	git tag git-basic-05-exploring-history

git-basic-06-ignore: git-basic-04-tracking-changes
	cd $(REPO_PATH)
	git tag git-basic-06-ignore
	mkdir pictures
	touch a.png b.png c.png pictures/cake1.jpg pictures/cake2.jpg
	printf '%s\n' "*.png" "pictures/" > .gitignore
	git add .gitignore
	git commit -m "Ignore png files and the pictures folder."

git-basic-07-remotes: git-basic-06-ignore
	cd $(REPO_PATH)
	git tag git-basic-07-remotes

git-basic-08-collab: git-basic-07-remotes
	cd $(REPO_PATH)
	git tag git-basic-08-collab
	printf '%s\n' "# Hummus" "## Ingredients" "* chickpeas" "* lemon" "* olive oil" "* salt" > hummus.md
	git add hummus.md
	git commit -m "Add ingredients for hummus"

git-basic-09-conflict: git-basic-08-collab
	cd $(REPO_PATH)
	git tag git-basic-09-conflict
	printf '%s\n' "# Guacamole" "## Ingredients" "* avocado (1.35)" "* lime (0.64)" "* salt (2)" "## Instructions" "* peel the avocados and put them into a bowl." > guacamole.md
	git add guacamole.md
	git commit -m "Merge changes from remote repository"


# --- Advanced Git Workshop ---
# 01-introduction: git init, add, commit
git-adv-01-introduction: git-basic-09-conflict
	cd $(REPO_PATH)
	git tag git-adv-01-introduction

git-adv-01-introduction-challenge-02: git-adv-01-introduction
	cd $(REPO_PATH)
	git tag git-adv-01-introduction-challenge-02
	printf '%s\n' "# Salsa" "## Ingredients" "## Instructions" > salsa.md
	git add salsa.md
	git commit -m "Add salsa recipe"

# 02-branching: branch, switch, reformat recipe as YAML
git-adv-02-branching: git-adv-01-introduction-challenge-02
	cd $(REPO_PATH)
	git tag git-adv-02-branching
	git branch yaml-format
	git switch yaml-format
	printf '%s\n' \
		"name: Guacamole" \
		"ingredients:" \
		"  avocado: 1.35" \
		"  lime: 0.64" \
		"  salt: 2" \
		'instructions: ""' > guacamole.md
	git add guacamole.md
	git commit -m "Reformat recipe to use YAML."
	git switch main

# 02-branching challenge: rename guacamole.md to guacamole.yaml on the yaml-format branch
git-adv-02-branching-challenge-01: git-adv-02-branching
	cd $(REPO_PATH)
	git tag git-adv-02-branching-challenge-01
	git switch yaml-format
	git mv guacamole.md guacamole.yaml
	git commit -m "Rename recipe file to use .yaml extension."
	git switch main

# 02-branching challenge: rename yaml-format to feature/yaml-format
git-adv-02-branching-challenge-02: git-adv-02-branching
	cd $(REPO_PATH)
	git tag git-adv-02-branching-challenge-02
	git branch -m yaml-format feature/yaml-format

# 02-branching challenge: create an unmerged branch, then delete it (-d fails, -D forces it)
git-adv-02-branching-challenge-03: git-adv-02-branching
	cd $(REPO_PATH)
	git tag git-adv-02-branching-challenge-03
	git switch main
	git switch -c dessert-recipes
	printf '%s\n' "# Chocolate Chip Cookies" "## Ingredients" "## Instructions" > cookies.md
	git add cookies.md
	git commit -m "Add chocolate chip cookies recipe."
	git switch main
	git branch -d dessert-recipes
	git branch -D dessert-recipes

# 03-remote (challenges excluded on purpose)
git-adv-03-remote: git-adv-02-branching
	cd $(REPO_PATH)
	git tag git-adv-03-remote
	git switch main
	# Add a new line to the guacamole recipe
	printf '%s\n' "* squeeze the juice of the lime into the bowl." >> guacamole.md
	git add guacamole.md
	git commit -m "Extend guacamole recipe to include lime juice."

# 03-remote challenge
# 04-undo assumes this challenge already exists
# A participant who wants to attempt the challenge themselves should start from `git-adv-03-remote` and do this part by hand instead
git-adv-03-remote-challenge-01: git-adv-03-remote
	cd $(REPO_PATH)
	git tag git-adv-03-remote-challenge-01
	git branch bean-dip
	git switch bean-dip
	printf '%s\n' "# Bean Dip" "## Ingredients" "- beans" "## Instructions" > bean-dip.md
	git add bean-dip.md
	git commit -m "Add bean dip recipe."
	git switch main

# 03-remote exercise: simulate someone editing README.md directly on the remote
git-adv-03-remote-challenge-02: git-adv-03-remote-challenge-01
	cd $(REPO_PATH)
	git tag git-adv-03-remote-challenge-02
	printf '%s\n' "# Recipes Repository" "" "This repository contains a collection of recipes that I have collected over the years." "We are using git to manage and collaborate on these recipes."> README.md
	git add README.md
	git commit -m "Add initial README with repository information"

# 04-undo: a commit worth reverting/resetting live
# TODO (?): the rest of episode 04 (git reset --hard, detached HEAD, alt-history) is not scripted here
# git reset --hard and the detached HEAD demo reuse the same commit and don't affect the main branch, so the next episode still starts from a clean state
git-adv-04-undo: git-adv-03-remote-challenge-02
	cd $(REPO_PATH)
	git tag git-adv-04-undo
	mkdir -p breads
	printf '%s\n' "# Banana Bread" "## Ingredients" "## Instructions" > breads/banana-bread.md
	printf '%s\n' "# French Baguette" "## Ingredients" "## Instructions" > breads/french-baguette.md
	git add breads
	git commit -m "Add bread recipe templates"
	printf '%s\n' "# Tomato Soup" "## Ingredients" "## Instructions" > tomato-soup.md
	git add tomato-soup.md
	git commit -m "Add tomato soup recipe"
	printf '%s\n' "# Pea Soup" "## Ingredients" "- watermelon" "## Instructions" > pea-soup.md
	git add pea-soup.md
	git commit -m "Add ingredients to pea soup recipe"
	git revert --no-edit HEAD
	git reset HEAD~2 --hard

# 04-undo exercise: soup-recipes branch - revert, reset --hard , reset (leave staged), recommit
git-adv-04-undo-exercise-01: git-adv-04-undo
	cd $(REPO_PATH)
	git tag git-adv-04-undo-exercise-01
	git switch main
	git checkout -b soup-recipes
	mkdir -p soups
	printf '%s\n' "# Tomato Soup" > soups/tomato-soup.md
	git add soups/tomato-soup.md
	git commit -m "Create tomato soup recipe"
	printf '%s\n' "## Ingredients" "- tomatoes (6)" >> soups/tomato-soup.md
	git add soups/tomato-soup.md
	git commit -m "Add tomato soup ingredients"
	printf '%s\n' "## Instructions" "- Chop tomatoes" >> soups/tomato-soup.md
	git add soups/tomato-soup.md
	git commit -m "Add chopping instructions"
	printf '%s\n' "- Add water and boil" >> soups/tomato-soup.md
	git add soups/tomato-soup.md
	git commit -m "Finish instructions"
	git revert --no-edit HEAD
	git reset HEAD~2 --hard
	git reset HEAD~1
	git add soups/tomato-soup.md
	git commit -m "Add tomato soup with basic ingredients"
	git switch main

# 05-merging: fast-forward merge, non-fast-forward merge, and a conflict to resolve live
# The exercises have no single solution, so they are excluded on purpose
git-adv-05-merging: git-adv-04-undo
	cd $(REPO_PATH)
	git tag git-adv-05-merging
	git branch pie-recipes
	git switch pie-recipes
	mkdir pies
	printf '%s\n' "# Apple Pie" "## Ingredients" "## Instructions" > pies/apple-pie.md
	git add pies/apple-pie.md
	git commit -m "Add apple pie recipe"
	git switch main
	git merge pie-recipes

	git switch main
	git branch salsa-instructions
	git switch salsa-instructions
	printf '%s\n' "instructions:" "  1. Dice tomatoes and onions." "  2. Mix together in a bowl." >> salsa.md
	git add salsa.md
	git commit -m "Add instructions to salsa recipe."
	git switch main
	git merge --no-ff salsa-instructions -m "Merge salsa-instructions branch into main."

	git switch main
	git branch modify-salsa-instructions
	git switch modify-salsa-instructions
	printf '%s\n' \
		"# Salsa" \
		"## Ingredients" \
		"## Instructions" \
		"  1. Dice tomatoes and onions." \
		"  2. Mix together in a bowl." \
		"  3. Add lime juice and salt to taste." > salsa.md
	git add salsa.md
	git commit -m "Modify salsa instructions to include lime juice and salt."
	git switch main
	printf '%s\n' \
		"# Salsa" \
		"## Ingredients" \
		"## Instructions" \
		"  1. Dice tomatoes and onions." \
		"  2. Mix together in a bowl." \
		"  3. Add cilantro and lime juice to taste." > salsa.md
	git add salsa.md
	git commit -m "Modify salsa instructions to include cilantro and lime juice."
	git merge modify-salsa-instructions
	printf '%s\n' \
		"# Salsa" \
		"## Ingredients" \
		"## Instructions" \
		"  1. Dice tomatoes and onions." \
		"  2. Mix together in a bowl." \
		"  3. Add cilantro and lime juice to taste." > salsa.md
	git add salsa.md
	git commit -m "Resolve merge conflict in salsa.md."


# 05-merging exercise 1: fast-forward merge challenge (exercise 2 stays free-form, excluded)
git-adv-05-merging-exercise-01: git-adv-05-merging
	cd $(REPO_PATH)
	git tag git-adv-05-merging-exercise-01
	git switch main
	git branch finish-pie-recipe
	git switch finish-pie-recipe
	printf '%s\n' \
		"# Instructions" \
		"  1. Preheat oven to 350F." \
		"  2. Make the Pie" \
		"  3. Bake for 45 minutes." >> pies/apple-pie.md
	git add pies/apple-pie.md
	git commit -m "Add instructions to apple pie recipe."
	git switch main
	git merge finish-pie-recipe

# 06-tags: a lightweight tag and an annotated tag
git-adv-06-tags: git-adv-05-merging-exercise-01
	cd $(REPO_PATH)
	git tag git-adv-06-tags
	git branch git-adv-06-tags
	git tag 1.0.0
	git tag -a 2.0.0 -m "Second Release"

# 06-tags exercise: tag the "Reformat recipe to use YAML." commit as 3.0.0
git-adv-06-tags-exercise-01: git-adv-06-tags
	cd $(REPO_PATH)
	git tag git-adv-06-tags-exercise-01
	git tag -a 3.0.0 yaml-format -m "Reformat recipe to use YAML"

# 09-forking: simulate the forking workflow via an `upstream` remote
# Requires REMOTE_REPO to already be a fork of UPSTREAM_REPO for the push/fetch steps to do anything
# TODO: this may not be needed. (In the real workshop, each student forks REMOTE_REPO themselves on GitHub, so REMOTE_REPO becomes their own "upstream" - we don't need a separate UPSTREAM_REPO here either)
git-adv-09-forking: git-adv-06-tags
	cd $(REPO_PATH)
	git tag git-adv-09-forking
	git branch myfeature
	git switch myfeature
	printf '%s\n' "# Chips" "## Ingredients" "## Instructions" > chips.md
	git add chips.md
	git commit -m "Add chips recipe"

# 12-large-files: track a "large" file with git lfs
git-adv-12-large-files: git-adv-09-forking
	cd $(REPO_PATH)
	git tag git-adv-12-large-files
	git switch main
	git lfs install
	echo "This is a very large report." > report.pdf
	git lfs track report.pdf
	git add .gitattributes
	git commit -m "Setup LFS tracking"
	git add report.pdf
	git commit -m "Add final report to the repository"

# 13-cherrypick: cherry-pick a commit from bean-dip into main
git-adv-13-cherrypick: git-adv-12-large-files
	cd $(REPO_PATH)
	git tag git-adv-13-cherrypick
	git switch bean-dip
	printf '%s\n' \
		"# Market A" \
		"* avocado: 1.35 per unit." \
		"* lime: 0.64 per unit" \
		"* salt: 2 per kg" \
		"* black beans: 0.99 per can" > groceries.md
	git add groceries.md
	git commit -m "Add bean dip ingredients to groceries"
	git checkout main
	git cherry-pick bean-dip

# 13-cherrypick exercise: create a cookies branch, cherry-pick just the groceries.md change into main
git-adv-13-cherrypick-exercise-01: git-adv-13-cherrypick
	cd $(REPO_PATH)
	git switch main
	git tag git-adv-13-cherrypick-exercise-01
	git branch cookies
	git switch cookies
	mkdir -p cookies
	printf '%s\n' "# Chocolate Chip Cookies" "## Ingredients" "## Instructions" > cookies/chocolate-chip-cookies.md
	git add cookies/chocolate-chip-cookies.md
	git commit -m "Add chocolate chip cookies recipe"
	printf '%s\n' "* chocolate chips: 3.49 per bag" >> groceries.md
	git add groceries.md
	git commit -m "Add chocolate chips to groceries"
	printf '%s\n' \
		"1. Cream the butter and sugar." \
		"2. Mix in the chocolate chips." \
		"3. Bake at 375F for 10 minutes." >> cookies/chocolate-chip-cookies.md
	git add cookies/chocolate-chip-cookies.md
	git commit -m "Add instructions to chocolate chip cookies recipe"
	git switch main
	git cherry-pick cookies~1

# 13-cherrypick exercise: cherry-pick a range of 2 commits touching groceries.md
git-adv-13-cherrypick-exercise-02: git-adv-13-cherrypick-exercise-01
	cd $(REPO_PATH)
	git tag git-adv-13-cherrypick-exercise-02
	git switch cookies
	printf '%s\n' "# Sugar Cookies" "## Ingredients" "- sugar: 200g" "- flour: 300g" "- butter: 150g" "## Instructions" > cookies/sugar-cookies.md
	git add cookies/sugar-cookies.md
	git commit -m "Add sugar cookies recipe"
	printf '%s\n' "* sugar: 1.20 per kg" >> groceries.md
	git add groceries.md
	git commit -m "Add sugar to groceries"
	printf '%s\n' "* flour: 2.50 per kg" "* butter: 3.00 per kg" >> groceries.md
	git add groceries.md
	git commit -m "Add flour and butter to groceries"
	printf '%s\n' \
		"1. Cream the butter and sugar." \
		"2. Mix in the flour." \
		"3. Bake at 350F for 12 minutes." >> cookies/sugar-cookies.md
	git add cookies/sugar-cookies.md
	git commit -m "Add instructions to sugar cookies recipe"
	git switch main
	git cherry-pick cookies~3..cookies~1

# 13-cherrypick exercise: cherry-pick from a local "upstream" remote - a single commit, then a PR merge commit
# TODO: This is the Exercise: Cherry-picking at the bottom of the page, I changed the order since it looks like the 'Undoing Commits' exercise needs the merge commit that this one creates first
git-adv-13-cherrypick-exercise-upstream: git-adv-13-cherrypick
	cd $(REPO_PATH)
	git tag git-adv-13-cherrypick-exercise-upstream
# 	rm -rf $(WORKING_DIR)/upstream-cherry
# 	mkdir -p $(WORKING_DIR)/upstream-cherry
# 	cd $(WORKING_DIR)/upstream-cherry
# 	git init -q -b master
# 	printf '%s\n' "# Toast" "## Ingredients" "- bread" > toast.md
# 	git add toast.md
# 	git commit -q -m "Add toast recipe"
# 	git branch add-butter
# 	git switch -q add-butter
# 	printf '%s\n' "# Toast" "## Ingredients" "- bread" "- butter" > toast.md
# 	git add toast.md
# 	git commit -q -m "Add butter to toast"
# 	git switch -q master
# 	git merge --no-ff add-butter -m "Merge pull request #42 from upstream-org/add-butter" -q
# 	cd ../$(REPO_NAME)
# 	git branch develop main
# 	git checkout -b cherry develop
# 	git remote remove upstream 2>/dev/null || true
# 	git remote add upstream ../upstream-cherry
# 	git fetch upstream master
# 	git cherry-pick upstream/master~1
# 	git cherry-pick -m 1 --no-edit upstream/master

# 13-cherrypick exercise: revert the PR merge commit we just cherry-picked, hard-reset it away, then redo a commit via reset+recommit
git-adv-13-cherrypick-exercise-undoing-commits: git-adv-13-cherrypick-exercise-upstream
	cd $(REPO_PATH)
	git tag git-adv-13-cherrypick-exercise-undoing-commits
# 	git switch cherry
# 	git revert -m 1 --no-edit HEAD
# 	git reset HEAD~2 --hard
# 	git reset HEAD~1
# 	git add toast.md
# 	git commit -m "Add toast recipe"

# 14-squash-rebase: build a messy commit history on `pie-recipes` for a live interactive rebase demo
git-adv-14-squash-rebase: git-adv-13-cherrypick
	cd $(REPO_PATH)
	git tag git-adv-14-squash-rebase
	git branch pie-recipes
	git switch pie-recipes
	printf '%s\n' "# Pie Recipes" > pie-recipes.md
	git add pie-recipes.md
	git commit -m "Initial commit with recipe files"
	printf '%s\n' "" "## Apple Pie" "### Ingredients" "- apples" "### Instructions" >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Add Apple Pie recipe"
	printf '%s\n' "" "## Pecan Pie" "### Ingredients" "- pecens" "- corn syrup" >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Add recipe for Pecan Pie with ingredients"
	sed -i 's/pecens/pecans/' pie-recipes.md
	git add pie-recipes.md
	git commit -m "Fix typo in ingredients"
	printf '%s\n' "### Instructions" "1. Preheat oven to 350F." >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Additional instructions to pecan pie recipe"
	printf '%s\n' "2. Bake for 45 minutes." >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Complete pecan pie recipe instructions"

# 14-squash-rebase exercise 1: squash the typo-fix commit into the pecan pie commit
git-adv-14-squash-rebase-exercise-01: git-adv-14-squash-rebase
	cd $(REPO_PATH)
	git switch pie-recipes
	git reset --hard HEAD~4
	printf '%s\n' "" "## Pecan Pie" "### Ingredients" "- pecans" "- corn syrup" >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Add recipe for Pecan Pie with ingredients"
	printf '%s\n' "### Instructions" "1. Preheat oven to 350F." >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Additional instructions to pecan pie recipe"
	printf '%s\n' "2. Bake for 45 minutes." >> pie-recipes.md
	git add pie-recipes.md
	git commit -m "Complete pecan pie recipe instructions"

# 14-squash-rebase exercise 2: 3 commits (one with a typo'd message, fixed via amend), then squashed
# TODO: On the 14-squash-rebase.md file that is public right now there are two challenge blocks for the Exercise 2.
git-adv-14-squash-rebase-exercise-02: git-adv-14-squash-rebase
	cd $(REPO_PATH)
	git tag git-adv-14-squash-rebase-exercise-02
	git switch main
	printf '%s\n' "flour" > pancake.md
	git add pancake.md
	git commit -m "Add flour"
	printf '%s\n' "milk" >> pancake.md
	git add pancake.md
	git commit -m "Add milk"
	printf '%s\n' "egg" >> pancake.md
	git add pancake.md
	git commit -m "Add eg"
	git commit --amend -m "Add egg"
	git reset --soft HEAD~3
	git commit -m "Add ingredients to pancake recipe"
	printf '%s\n' "butter" >> pancake.md
	git add pancake.md
	git commit --amend --no-edit

# 15-hooks-actions: a pre-commit hook running flake8, plus a file with an intentional lint error
# Committing hello.py (and watching the hook block it) is demoed live
# TODO: Challenges at the end of the section
git-adv-15-hooks-actions: git-adv-14-squash-rebase
	cd $(REPO_PATH)
	git tag git-adv-15-hooks-actions
# 	git switch main
# 	pip install flake8
# 	printf '%s\n' \
# 		"#!/usr/bin/env bash" \
# 		"" \
# 		"set -eo pipefail" \
# 		"flake8 hello.py" \
# 		"echo \"flake8 passed!\"" > .git/hooks/pre-commit
# 	chmod +x .git/hooks/pre-commit
# 	printf '%s\n' "print('Hello world!'')" > hello.py

# 15-hooks-actions exercise 1 (Challenge 1): a commit-msg hook enforcing feat:/fix:/docs: prefixes
# pre-commit is temporarily moved aside so the flake8/hello.py failure doesn't mask this hook's own test
git-adv-15-hooks-actions-challenge-01: git-adv-15-hooks-actions
	cd $(REPO_PATH)
	git tag git-adv-15-hooks-actions-challenge-01
# 	printf '%s\n' \
# 		"commit_msg=\$$(cat \"\$$1\")" \
# 		"" \
# 		"if ! echo \"\$$commit_msg\" | grep -qE \"^(feat|fix|docs):\"; then" \
# 		"    echo \"ERROR: Commit message must start with 'feat:', 'fix:' or 'docs:'\"" \
# 		"    exit 1" \
# 		"fi" > .git/hooks/commit-msg
# 	chmod +x .git/hooks/commit-msg
# 	mv .git/hooks/pre-commit .git/hooks/pre-commit.bak
# 	printf '%s\n' "test file" > testfile.txt
# 	git add testfile.txt
# 	git commit -m "updated stuff"
# 	git commit -m "feat: add test file"
# 	mv .git/hooks/pre-commit.bak .git/hooks/pre-commit

entire-repository: git-adv-15-hooks-actions-challenge-01
	cd $(REPO_PATH)
	git remote add origin $(REMOTE_REPO)
	git push --force --set-upstream origin main
	git push --tags --force origin
	git push --all --force origin

create-woodworking-repo:
	@echo "Creating woodworking repository..."
	./instructors/files/create-woodworking-repo.sh -r $(FORKING_REPO)
