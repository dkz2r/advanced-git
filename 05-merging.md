---
title: "Merging"
teaching: 0
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- Learn about `git merge`.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I merge a branch changes?

::::::::::::::::::::::::::::::::::::::::::::::::::

When you are collaborating, you will have to merge a branch independent if your branch may or may not have diverged from the main branch. Most of the Git hosting platform like GiHub or Gitlab allows you to merge a branch from their web interface but you can also merge the branches from your machine using `git merge`.

There are 2 ways to merge:

- non-fast-forward merged (recommended)

- fast forward merged

![Merging diagram.](fig/09-merging.png){alt="A diagram showing different types of Git merges."}


## Fast-forward Merge

If there are no conflicts with the main branch, we can perform a "fast-forward" merge. This works
by moving the branch pointer to the latest commit in the target branch. This is the default behaviour
of `git merge` (when possible).

Let's create a new branch `pie-recipes` and add a commit to it:

```bash
git branch pie-recipes
git switch pie-recipes
mkdir pies
nano pies/apple-pie.md
```

```markdown
# Apple Pie
## Ingredients
## Instructions
```

```bash
git add pies/apple-pie.md
git commit -m "Add apple pie recipe."
```

When we merge, we need to be on the branch that we want to merge into.
At the moment, we are still on the `pie-recipes` branch, so let's switch back to the `main` branch and merge the changes from `pie-recipes`:

```bash
git switch main
git merge pie-recipes
```

```output
$ git merge pie-recipes
Updating 6c17573..75f4fca
Fast-forward
 pies/apple-pie.md | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 pies/apple-pie.md
```

If we look at the log, we can see that the commit that we made on the `pie-recipes` branch is now
a part of the `main` branch:

```output
$ git log --oneline --graph -n 5
* 75f4fca (HEAD -> main, pie-recipes) Add apple pie recipe
* 6c17573 Add tomato soup recipe
* daaaaa7 Add bread recipe templates
* 1fda23d Add initial README with repository information
* 8a53062 Extend guacamole recipe to include lime juice.
```

::: callout

Note that our old branch is still there!

```output
$ git branch -avv
  bean-dip     68850ec Add bean dip recipe.
* main         75f4fca Add apple pie recipe
  pie-recipes  75f4fca Add apple pie recipe
  soup-recipes 8dbd9fe Add tomato soup with basic ingredients
  yaml-format  0bb0a0c Reformat recipe to use YAML.
```

It's just that both branches now point to the same commit. Until we specifically delete the branch,
it will remain in the repository.

:::

If using the fast-forward merge, it is impossible to see from the `git` history which of the commit objects together have implemented a feature. You would have to manually read all the log messages. Reverting a whole feature (i.e. a group of commits), is a true headache in the latter situation, whereas it is easily done if the --no-ff flag was used.

For a good illustration of fast-forward merge (and other concepts), see this thread: https://stackoverflow.com/questions/9069061/what-effect-does-the-no-ff-flag-have-for-git-merge

## Non-fast-forward Merge

A non fast-forward merge makes a new commit that ties together the histories of both branches.

Let's make a new branch and add a commit to it:

```bash
git branch salsa-instructions
git switch salsa-instructions
nano salsa.md
```

```yaml
instructions:
  1. Dice tomatoes and onions.
  2. Mix together in a bowl.
```

```bash
git add salsa.md
git commit -m "Add instructions to salsa recipe."
```

Now, let's move back to the main branch and merge the changes from the `salsa-instructions` branch
using a non-fast-forward merge:

```bash
git switch main
git merge --no-ff salsa-instructions -m "Merge salsa-instructions branch into main."
```

```output
$ git merge --no-ff salsa-instructions -m "Merge salsa-instructions branch into main."
Merge made by the 'ort' strategy.
 salsa.md | 2 ++
 1 file changed, 2 insertions(+)
```

Let's look at the log to see what happened:

```output
$ git log --oneline --graph -n 5
*   381314b (HEAD -> main) Merge salsa-instructions branch into main.
|\
| * 3572596 (salsa-instructions) Add instructions to the salsa recipe
|/
* 75f4fca (pie-recipes) Add apple pie recipe
* 6c17573 Add tomato soup recipe
* daaaaa7 Add bread recipe templates
```

The `--no-ff` flag causes the merge to always create a new commit object, even if the merge could
be performed with a fast-forward. This avoids losing information about the historical existence of
a feature branch and groups together all commits that together added the feature.

## Merge Conflicts

When merging branches, it's not uncommon to encounter a "merge conflict". This happens when the
same part of the same file has been modified in both the source and target branches. In these cases,
git will pause the merge and ask you to resolve the conflict manually.

Let's create a conflict by modifying the same line in both branches.

```bash
git switch main
git branch modify-salsa-instructions
git switch modify-salsa-instructions
nano salsa.md
```

And let's change the final step to something more informative:

```markdown
instructions:
  1. Dice tomatoes and onions.
  2. Mix together in a bowl.
  3. Add lime juice and salt to taste.
```

Commit the change:

```bash
git add salsa.md
git commit -m "Modify salsa instructions to include lime juice and salt."
```

Now, let's switch back to the `main` branch and modify the same file differently:

```bash
git switch main
nano salsa.md
```

Change the final step in `salsa.md` to:
```markdown
instructions:
  1. Dice tomatoes and onions.
  2. Mix together in a bowl.
  3. Add cilantro and lime juice to taste.
```

Commit the change:

```bash
git add salsa.md
git commit -m "Modify salsa instructions to include cilantro and lime juice."
```

Now, let's try to merge the `modify-salsa-instructions` branch into `main`:

```bash
git merge modify-salsa-instructions
```

```output
$ git merge modify-salsa-instructions
Auto-merging salsa.md
CONFLICT (content): Merge conflict in salsa.md
Automatic merge failed; fix conflicts and then commit the result.
```

In addition to this message, our branch name in the terminal prompt may also be prefixed with
`(main|MERGING)` to indicate that we are in the middle of a merge, and not in the normal flow of
git operations.

Git has marked the conflict in the `salsa.md` file. Let's open it to see what happened:

```
$ cat salsa.md
# Salsa
## Ingredients
## Instructions
  1. Dice tomatoes and onions
  2. Mix together in a bowl
'<<<<<<< HEAD
  3. Add cilantro and lime juice to taste.
=======
  3. Add lime juice and salt to taste
'>>>>>>> modify-salsa-instructions
```

The lines between `<<<<<< HEAD` and `=======` show the changes from the `main` branch, while the
lines between `=======` and `>>>>>>> modify-salsa-instructions` show the changes from
the `modify-salsa-instructions` branch.

There are tools and editors that can help you resolve merge conflicts, but at its core, all we need
to do is decide which changes to keep. We can keep one side, the other side, or even combine
both changes.

You can resolve the conflict however you like - as long as the final file is valid and no longer
contains the merge conflict markers.

Upon saving the file, however, the merge is not yet complete. We need to stage the resolved file and
commit the merge:

```bash
git add salsa.md
git commit -m "Resolve merge conflict in salsa.md."
```

We can see the branch / merge process in our log:

```output
$ git log --oneline --graph -n 7
*   cb3c272 (HEAD -> main) Resolve merge conflict in salsa.md.
|\
| * 54f4518 (modify-salsa-instructions) Modify salsa instructions to include lime juice and salt.
* | 9a8d10a Modify salsa instructions to include cilantro and lime juice.
|/
*   381314b Merge add-instructions branch into main.
|\
| * 3572596 (add-instructions) Add instructions to the salsa recipe
|/
* 75f4fca (pie-recipes) Add apple pie recipe
* 6c17573 (tag: git-adv-04-undo-exercise-01) Add tomato soup recipe
...
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise: Creating a fast-forward merge.

Create a branch in your repository for finishing the apple pie recipe by adding instructions.
Then, merge the branch back into `main` using a fast-forward merge.

:::::::::::::::  solution

```bash
git branch finish-pie-recipe
git switch finish-pie-recipe
nano pies/apple-pie.md
```

```markdown
# Instructions
  1. Preheat oven to 350F.
  2. Make the Pie
  3. Bake for 45 minutes.
```

```bash
git add pies/apple-pie.md
git commit -m "Add instructions to apple pie recipe."
git switch main
git merge finish-pie-recipe
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Exercise: Resolving a merge conflict.

Create a merge conflict by modifying the same line in both the `main` branch and a new branch.
Then, merge the new branch into `main`, resolve the conflict, and complete the merge.

This is free-form, so there is no single correct solution.

:::::::::::::::  solution


```bash
git switch main
nano pies.md
git add pies/apple-pie.md
git commit -m "Add ingredients to the apple pie recipe."
git branch modify-apple-pie
git switch modify-apple-pie
nano pies/apple-pie.md
git add pies/apple-pie.md
git commit -m "Add basic ingredients to the apple pie recipe."
git switch main
nano pies/apple-pie.md
git add pies/apple-pie.md
git commit -m "Modify apple pie recipe to include additional ingredients."
git merge modify-apple-pie
# Resolve the conflict in pies/apple-pie.md
git add pies/apple-pie.md
git commit -m "Resolve merge conflict in pies/apple-pie.md."
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::


### Three-way Merge

Similar to `--no-ff`, but there may be dragons. Forced upon you when there's an intermediate change since you branched.
May prompt you to manually resolve

```bash
git merge <branch> [-s <strategy>]
```

See https://git-scm.com/docs/merge-strategies for a zillion options (“patience”, “octopus”, etc),  But also git is only so smart and you are probably smarter.

::: callout
There are a number of external tools that have a graphical interface to allow for merge conflict resolution. Some of these include: [kdiff3](https://kdiff3.sourceforge.net) (Windows, Mac, Linux), [Meld](https://meldmerge.org) (Windows, Linux), [P4Merge](https://www.perforce.com/products/helix-core-apps/merge-diff-tool-p4merge) (Windows, Mac, Linux),  [opendiff](https://github.com/andrewchaa/opendiff) (Mac), [vimdiff](https://devhints.io/vim-diff) (for Vim users), [Beyond Compare](https://www.scootersoftware.com/download.php?zz=dl3_en), GitHub web interface. **We do not endorse any of them and use at your own risk.** In any case, using a graphical interface does not substitute for understanding what is happening under the hood.
:::

:::::::::::::::::::::::::::::::::::::::: keypoints

- `git merge --no-ff` is the best way to merge changes
- `git merge --ff-only` is a good way to pull down changes from remote
- merge conflicts happen when the same part of the same file has been modified in both branches
- merge conflicts must be resolved manually

::::::::::::::::::::::::::::::::::::::::::::::::::
