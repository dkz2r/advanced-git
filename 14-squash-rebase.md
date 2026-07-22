---
title: "Interactive Rebase and Squash"
teaching: 0
exercises: 0
---

:::::::::::::::::::::::::::::::::::::::: questions

- Why would I rebase a branch?
- When would I squash commits during a rebase?

::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::: objectives

- Understand the reasons for interactive rebases.
- Remove amending commits from the history.

::::::::::::::::::::::::::::::::::::::::::::::::::

## Interactive Rebase

The process of getting a pull request or merge request accepted and merged into
the upstream repository can require several updates to the original proposed
changes.
These changes may be functional fixes or just changes due to coding policies
required for the project.
This often results in multiple changes concerning the same piece of the code or
document to be both spatially and temporally apart from each other in the Git
history.
For some projects a cluttered history is not acceptable and you may need to
clean up the history.

Git provides a command to modify the history of a branch called an *interactive
rebase*.

### Setting up a situation to do a rebase

Let's set up a branch that contains multiple commits modifying the same file
to demonstrate how to use an interactive rebase to clean up the history.

We're going to make a series of commits to a particular branch, as though we were working on a feature. 

To start with, we'll add a new file...

```bash
nano apple-pie.md
```

```markdown
# Apple Pie
## Ingredients
## Instructions
```

```bash
git add apple-pie.md
git commit -m "Add Apple Pie recipe"
```

Then we'll add another file...

```bash
nano pecan-pie.md
```

```markdown
# Pecan Pie
## Ingredients
- pecens
- sugar
## Instructions
```

```bash
git add pecan-pie.md
git commit -m "Add Pecan Pie recipe with ingredients"
```

But we accidentally made a typo! We fix it in the next commit...

```markdown
# Pecan Pie
## Ingredients
- pecans <- Fix the typo here
- sugar
## Instructions
```

```bash
git add pecan-pie.md
git commit -m "Fix typo in ingredients"
```

And finally we edit that same file again...

```bash
nano pecan-pie.md
```

```markdown
# Pecan Pie
## Ingredients
- pecans
- sugar
## Instructions
- Preheat the oven
```

```bash
git add pecan-pie.md
git commit -m "Additional nstructions to pecan pie recipe."
```

Then we'll go back and edit our first file...


```bash
nano apple-pie.md
```

```markdown
# Apple Pie
## Ingredients
- apples
## Instructions
```

```bash
git add apple-pie.md
git commit -m "Add Ingredients to Apple Pie recipe"
```

### Performing an Interactive Rebase

Let's first look at the history of our branch

```bash
git log --oneline pie-recipes -n 6
```

```output
$ git log --oneline pie-recipes -n 6
b9797c6 (HEAD -> pie-recipes) Add ingredients to Apple Pie recipe
3aac6a9 Additional nstructions to pecan pie recipe.
868e4f3 Fix type in pecan pie ingredients
6c19e85 Add Pecan Pie recipe with ingredients.
fde1722 Add Apple Pie recipe
460c628 Add bean dip ingredients to groceries
66cbdd6 Add final cookbook to the repository
```

We're ready to add our changes back into the main branch, but we want our merge request to be tidier. There's a couple things we notice:

1. There's two commits one right after the other where we add a pecan pie recipe, and then immediately notice and fix a typo. This can be one commit.
2. We added the apple pie recipe, then much later we added the ingredients. Maybe these commits should be next to each other?

For cleaning up the history we want to focus on the first 4 commit of the branch. We call the "rebase" command we talked about earlier, but this time instead of specifying a different branch, we say that we want to rebase onto the commit five commits being our current HEAD. We also add a flag `-i`, saying that we want this to be an "interactive rebase":

```bash
git rebase -i HEAD~5
```

Git will open an editor with a list of the requested commits that looks something like this:

```output
pick fde1722 Add Apple Pie recipe
pick 6c19e85 Add Pecan Pie recipe with ingredients.
pick 868e4f3 Fix typo in pecan pie ingredients
pick 3aac6a9 Additional nstructions to pecan pie recipe.
pick b9797c6 Add ingredients to Apple Pie recipe

# Rebase deeb7a6..376a80c onto deeb7a6 (4 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup [-C | -c] <commit> = like "squash" but keep only the previous
#                    commit's log message, unless -C is used, in which case
#                    keep only this commit's message; -c is same as -C but
#                    opens the editor
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
# .       create a merge commit using the original merge commit's
# .       message (or the oneline, if no original merge commit was
# .       specified); use -c <commit> to reword the commit message
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
```

Everything in the bottom part of the editor (all the lines that start with "#") are ignored. What we really care about are the lines at the top with our commits. Each line contains a command, followed by the commit hash for that commit, and finally the message that commit was made with.

In order to make our changes to our commits, we need to modify the commands in front of the hashes to specify what it is we want to do with each commit.

Git provides different options for `<cmd>` to modify the specific commit. Below you find a selection of commands that are most often used in basic interactive rebasing.

- **pick**: Use this commit
- **reword**: Use this commit, but adapt the commit message
- **edit**: Use commit, but pause to shell before committing
- **squash**: Use commit, but as part of the previous commit combining commit
  messages
- **fixup**: Like squash, but keep only a single commit message
- **drop**: Remove commit

Initially all commits are listed with **pick**, as this would recreate the same state as before the interactive rebase was started.
You are now free to change the order of those commits as long as dependencies are retained.

The first thing we want to do is combine those two commits for the Pecan Pie recipe, where we noticed a typo right away. We can use the "fixup" command, which combines the changes made in the specific commit with the previous commit, keeping the commit message from the previous commit:

```output
pick fde1722 Add Apple Pie recipe
pick 6c19e85 Add Pecan Pie recipe with ingredients.
fixup 868e4f3 Fix typo in pecan pie ingredients
pick 3aac6a9 Additional nstructions to pecan pie recipe.
pick b9797c6 Add ingredients to Apple Pie recipe
```

We also notice that we made a typo in that previous commit! We can fix that as long as we're here by setting that commit to "reword":

```output
pick fde1722 Add Apple Pie recipe
pick 6c19e85 Add Pecan Pie recipe with ingredients.
fixup 868e4f3 Fix typo in pecan pie ingredients
reword 3aac6a9 Additional nstructions to pecan pie recipe.
pick b9797c6 Add ingredients to Apple Pie recipe
```

Now we save this file and exit. Git will start to perform the rebase, stopping at the commit we said we wanted to "reword" to let us modify the commit message, as though we were performing a `git commit --amend`.

After the rebase is complete, you can look at the rewritten history.

```bash
$ git log --oneline pie-recipes -n 8
6b1cb35 (HEAD -> pie-recipes) Add ingredients to Apple Pie recipe
4a15cec Additional instructions to pecan pie recipe.
aab2fe8 Add Pecan Pie recipe with ingredients.
fde1722 Add Apple Pie recipe
460c628 (origin/main, origin/HEAD, main) Add bean dip ingredients to groceries
66cbdd6 Add final report to the repository
```

The typo commit has been removed! Let's take a look at that specific commit now:

```bash
$ git show aab2fe8
commit aab2fe89ee418c40c6bb487741e50ff32a477e21
Author: Jonathan Hartman <hartman@itc.rwth-aachen.de>
Date:   Wed Jul 22 06:51:19 2026 +0200

    Add Pecan Pie recipe with ingredients.

diff --git a/pecan-pie.md b/pecan-pie.md
new file mode 100644
index 0000000..c0ca146
--- /dev/null
+++ b/pecan-pie.md
@@ -0,0 +1,5 @@
+# Pecan Pie
+## Ingredients
+- pecans
+- sugar
+## Instructions
```

As far as anyone is concerned, that typo and the commit fixing it never happened. Both changes are now "squashed" together into the same commit.

### Reordering Commits

We aren't just limited to the commands listed in a rebase however! Since a rebase is just "replaying" the commits on top of the specified commit, we can use the interactive rebase to put the commits back in with any order.

Let's look at our log again:

```bash
$ git log --oneline pie-recipes -n 8
6b1cb35 (HEAD -> pie-recipes) Add ingredients to Apple Pie recipe
4a15cec Additional instructions to pecan pie recipe.
aab2fe8 Add Pecan Pie recipe with ingredients.
fde1722 Add Apple Pie recipe
460c628 (origin/main, origin/HEAD, main) Add bean dip ingredients to groceries
66cbdd6 Add final report to the repository
```

Looking at the commits related to Apple Pie, there is the initial commit where we add the recipe, then several commits later we finally get around to adding ingredients. Let's move these commits so that they come one after the other:

```bash
git rebase -i HEAD~4
```

```bash
pick fde1722 Add Apple Pie recipe
pick 6b1cb35 Add ingredients to Apple Pie recipe
pick aab2fe8 Add Pecan Pie recipe with ingredients.
pick 4a15cec Additional instructions to pecan pie recipe.
```

In this case, I've moved the entire line with the commit "Add ingredients to Apple Pie recipe" two lines up, so that it comes right after the commit where we start the apple pie recipe.

Save the file and let git do complete the rebase.

Looking at our log again, we can see that the commit did in fact move:

```bash
$ git log --oneline pie-recipes -n 4
4a18d1d (HEAD -> pie-recipes) Additional instructions to pecan pie recipe.
b5ce1bd Add Pecan Pie recipe with ingredients.
f90ca38 Add ingredients to Apple Pie recipe
fde1722 Add Apple Pie recipe
```

## Important Notes about Rebase!

As with the standard rebase, the interactive rebase does also re-write the history of a branch. This means that if other people are working on that branch, it will be a real mess if anyone else makes commits and tries to push before you push your rebased commits. 

Generally, interactive rebase is something that is reserved for your local branches, where you are working on something independently. It's a way of cleaning up your history before you ask someone else to review your branch.

::: caution

If you have pushed your local branch to the remote, you will have to "force push" your branch to the remote, as the histories will no longer match. The command for this is "git push --force".

BE AWARE that if anyone else has cloned your branch when you do this, any changes that they have made between when you last cloned the repo and when you make your force push will be entirely deleted!

:::



::: challenge

## Exercise 1: Cleaning up history in a feature branch

Looking at our history, we can probably tidy up our history even more. Squash the commits related to Pecan Pies into a single commit, and do the same for the Apple Pie commits. Reword the commit messages to better explain the updated commits.

:::: solution

::::
:::


:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise 2: Squashing Commits and Amending

You are working on a pancake recipe and adding ingredients one by one, each as a separate commit.
You can track your history with `git log --oneline` at each step.

1. Create `pancake.md` and add the following ingredients as separate commits:
   - flour -> commit message: `Add flour`
   - milk -> commit message: `Add milk`
   - egg -> commit message: `Add eg` (this typo is intentional)
   - Fix the typo in the commit message before moving on.

::: hint

To correct only the commit message without touching the files, check `git commit --amend --help`.
:::

2. Squash all three commits into one.

::: hint
To squash multiple commits, look into `git rebase -i`.
:::

3. Oh, you forgot to butter. Add it to `pancake.md` and amend the existing commit without changing the commit message.

:::::::::::::::  solution

**Step 1:**

```bash
echo "flour" > pancake.md
git add pancake.md
git commit -m "Add flour"

echo "milk" >> pancake.md
git add pancake.md
git commit -m "Add milk"

echo "egg" >> pancake.md
git add pancake.md
git commit -m "Add eg"

git log --oneline
```
```output
<hash> (HEAD -> main) Add eg
<hash> Add milk
<hash> Add flour
```

```bash
git commit --amend -m "Add egg"

git log --oneline
```
```output
<hash> (HEAD -> main) Add egg
<hash> Add milk
<hash> Add flour
```

**Step 2:**

```bash
git rebase -i HEAD~3
```

In the editor, change `pick` to `s` for the last two commits:

```bash
pick <hash> Add flour
squash <hash> Add milk
squash <hash> Add egg
```

Save and exit. In the next editor, write a single commit message:
`Add ingredients to pancake recipe`

```bash
git log --oneline
```
```output
<hash> (HEAD -> main) Add ingredients to pancake recipe
```

**Step 3:**

```bash
echo "butter" >> pancake.md
git add pancake.md
git commit --amend --no-edit

git log --oneline
```
```output
<hash> (HEAD -> main) Add ingredients to pancake recipe
```
:::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::::

![GitFlow 1](fig/44-rebase.png)
![GitFlow 1](fig/45-squash.png)
![GitFlow 1](fig/46-bisect.png)
![GitFlow 1](fig/48-patches.png)

:::::::::::::::::::::::::::::::::::::::: keypoints

- Use an interactive rebase to clean up merge requests before the merge.
- Rebased branches need to be force-pushed due to history changes.
- Squashing can be used to combine multiple commits
- Depending on the project policy merge requests may need to be cleaned up
  before they are allowed upstream.

::::::::::::::::::::::::::::::::::::::::::::::::::

{% include links.md %}
