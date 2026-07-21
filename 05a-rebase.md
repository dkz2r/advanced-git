---
title: 'Rebasing'
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions

- What is rebasing and how does it differ from merging?
- When would I want to rebase instead of merge?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Create a feature branch and then rebase it onto the main branch

::::::::::::::::::::::::::::::::::::::::::::::::

## Rebasing vs Merging

We've just covered merging, which is a way of getting changes from one branch into another, but there's another method we can use called "rebasing".
When we thing about merging in the context of the tree analogy, it is like bending a branch back into the truck of the tree.
A rebase is more like cutting the branch off and reattaching it to a different part of the tree.

### When would I want to rebase instead of merge?

A frequent use case for rebasing is when you have a feature branch that you want to keep up to date with the main branch.
Say for instance we are working on a feature, and a colleague of ours pushes to the main branch.
We are working on similar parts of the codebase, and would like to incoroporate their changes into our feature branch, but merging the main branch into our feature branch would create a merge commit.
Instead, we can rebase our feature branch onto the main branch, which will replay our changes on top of the main branch, and keep a linear history.

### Why would I want to keep a linear history?

Mostly, just cleanliness.
A linear history is easier to read and understand, and makes it easier to use tools like `git bisect` to find bugs.
There are some people who prefer to work entirely with merges, and that's fine too.

## How to Rebase

Let's create a situation where we want to rebase our code. We'll start by creating a new branch off of main called `salads` and adding a file called `ceasar-salad.md` to it.

```bash
git switch main
git branch salads
git switch salads
nano ceasar-salad.md
```

```markdown
# Ceasar Salad
## Ingredients
## Instructions
```

We'll add and commit this file to our `salads` branch.

```bash
git add ceasar-salad.md
git commit -m "Add ceasar salad recipe"
```

Now, let's switch hats for a moment and pretend to be a colleague of ours.
This person was looking at the `groceries.md` file and thought that they would add a few more ingredients to it.

```bash
git switch main
nano groceries.md
```

```markdown
# Market A
* avocado: 1.35 per unit.
* lime: 0.64 per unit.
* salt: 2 per unit.

# Market B
* lettuce: 1 per unit
* parmesan cheese: 2 per unit
```

The add and commit this to the main branch.

```bash
git add groceries.md
git commit -m "Add lettuce and parmesan cheese to groceries"
```

Now let's switch back to our `salads` branch.
We haven't notice that our colleague has made changes to the main branch so we're still working.
We add some ingredients to our `ceasar-salad.md` file and commit them.

```bash
git switch salads
nano ceasar-salad.md
```

```markdown
# Ceasar Salad
## Ingredients
- lettuce
- parmesan cheese
## Instructions
```

```bash
git add ceasar-salad.md
git commit -m "Add ingredients to ceasar salad recipe"
```

At this point we pull the remote changes into our local repository and see a message that "main" has been updated.

We check the log and see this:
```bash
$ git log --oneline --graph --all -n 10
* 8655b28 (HEAD -> salads) Add ingredients to ceasar salad recipe
* f37c5b4 Add ceasar salad recipe
| * 4dcff9b (main) Add lettuce and parmesan cheese to groceries
|/
* 715dcdf (finish-pie-recipe) Add instructions to apple pie recipe.
*   451c1e3 (tag: git-adv-05-merging-exercise-01) Resolve merge conflict in sals
a.md.
|\
| * 379cd9b (modify-salsa-instructions) Modify salsa instructions to include lime juice and salt.
* | 1c53a20 Modify salsa instructions to include cilantro and lime juice.
|/
*   279870c Merge salsa-instructions branch into main.
|\
| * ce92bf6 (salsa-instructions) Add instructions to salsa recipe.
|/
* 193e279 (pie-recipes) Add apple pie recipe
```

So our change is on the "salads" branch, where the HEAD pointer is, but we can see that there is now an additional commit on main that we don't have in our branch.
We don't want to work on our branch without this commit, so we will rebase our branch onto main.
You can think of rebasing as sort of pulling the changes from our branch off and putting them aside, then putting them back on top of the main branch in order, as though we had made our changes after the changes on main.

```bash
git rebase main
```

You should get a message about "Rebasing (1/2)" and then "Rebasing (2/2)", then these will be replaced with a confirmation message:

```bash
$ git rebase main
Successfully rebased and updated refs/heads/salads.
```

When we look at the log again, we see this:

```bash
$ git log --oneline --graph --all -n 10
* 1f8d043 (HEAD -> salads) Add ingredients to ceasar salad recipe
* 0625bda Add ceasar salad recipe
* 4dcff9b (main) Add lettuce and parmesan cheese to groceries
* 715dcdf (finish-pie-recipe) Add instructions to apple pie recipe.
*   451c1e3 (tag: git-adv-05-merging-exercise-01) Resolve merge conflict in salsa.md.
|\
| * 379cd9b (modify-salsa-instructions) Modify salsa instructions to include lime juice and salt.
* | 1c53a20 Modify salsa instructions to include cilantro and lime juice.
|/
*   279870c Merge salsa-instructions branch into main.
|\
| * ce92bf6 (salsa-instructions) Add instructions to salsa recipe.
|/
* 193e279 (pie-recipes) Add apple pie recipe

```

Our changes are now on top of the main branch, and we don't have a merge commit in our history.

::: caution

A couple of things to note about rebasing:

1. Rebasing rewrites history, so you should never rebase commits that have been pushed to a shared repository. (If you do, you will have to force push your changes, which can cause problems for your collaborators.)
2. Rebasing can be a bit more complicated than merging, especially if there are conflicts. If you run into conflicts during a rebase, you will have to resolve them before you can continue the rebase. (when rebasing, if something goes wrong, you can see the state of the rebase with `git status` and you can abort the rebase with `git rebase --abort`)

:::

::::::::::::::::::::::::::::::::::::: challenge

## Challenge: A slightly messier rebase

Our example above was clean, but what would happen if the changes in main and the changes on our branch conflicted?

In this challenge, we will create a situation where we have a conflict during a rebase, by editing the same line in the same file on both branches.

You can either create your own version of this situation, or you can use the following commands to create this situation.

```bash
git switch main
nano groceries.md
```

```markdown
# Market A
* avocado: 1.35 per unit.
* lime: 0.64 per unit.
* salt: 2 per unit.
* tomatoes: 1.50 per unit   <-- add this line

# Market B
* lettuce: 1 per unit
* parmesan cheese: 2 per unit
```

```bash
git add groceries.md
git commit -m "Add tomatoes to groceries"
```

```bash
git switch salads
nano ceasar-salad.md
```

```markdown
# Ceasar Salad
## Ingredients
- lettuce
- parmesan cheese
## Instructions
- Wash the lettuce and slice it into strips.
```

```bash
git add ceasar-salad.md
git commit -m "Add instructions to ceasar salad recipe"
```

```bash
nano groceries.md
```

```markdown
# Market A
* avocado: 1.35 per unit.
* lime: 0.64 per unit.
* salt: 2 per unit.
* lemons: 1.00 per unit   <-- add this line

# Market B
* lettuce: 1 per unit
* parmesan cheese: 2 per unit
```

```bash
git add groceries.md
git commit -m "Add lemons to groceries"
```

Now, we have a situation where both branches have changes to the same line in the `groceries.md` file.
When we try to rebase our `salads` branch onto `main`, we will get a conflict.

```bash
git rebase main
```

Try the following:
1. Run `git log --oneline --graph --all -n 10` to see the history of the branches. Can you visually identify how the rebase will apply the changes from the `salads` branch on top of the `main` branch?
2. Run `git rebase main` to start the rebase. What happens? What does the output tell you?
3. Run `git status` to see the state of the rebase. What does it tell you?
4. Let's say we don't want to rebase anymore. How can we undo our rebase and go back to how the branch was before we started?

:::::::::::::::: solution

When you run `git rebase main`, you will see output that looks like this:

```output
$ git rebase main
Auto-merging groceries.md
CONFLICT (content): Merge conflict in groceries.md
error: could not apply 565b217... Add lemons to groceries
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
hint: Disable this message with "git config set advice.mergeConflict false"
Could not apply 565b217... # Add lemons to groceries
```

`git status` will show you something like this:

```output
$ git status
interactive rebase in progress; onto aa56a01
Last commands done (4 commands done):
   pick 0982782 # Add instructions to ceasar salad recipe
   pick 565b217 # Add lemons to groceries
  (see more in file .git/rebase-merge/done)
No commands remaining.
You are currently rebasing branch 'salads' on 'aa56a01'.
  (fix conflicts and then run "git rebase --continue")
  (use "git rebase --skip" to skip this patch)
  (use "git rebase --abort" to check out the original branch)

Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add <file>..." to mark resolution)
        both modified:   groceries.md

no changes added to commit (use "git add" and/or "git commit -a")
```

You can abort with `git rebase --abort`, which will return you to the state of the branch before you started the rebase.

If you want to continue with the rebase, you can run `cat groceries.md`, which will show you the conflict markers in the file:

```markdown
$ cat groceries.md
# Market A
* avocado: 1.35 per unit.
* lime: 0.64 per unit.
* salt: 2 per unit.
'<<<<<<< HEAD
* tomatoes: 1.50 per unit
=======
* lemons: 1.00 per unit
'>>>>>>> 565b217 (Add lemons to groceries)

# Market B
* lettuce: 1 per unit
* parmesan cheese: 2 per unit
```

You can edit the file to resolve the conflict, then add the file and continue the rebase.

```bash
git add groceries.md
git commit -m "Resolve conflict in groceries.md"
git rebase --continue
```

:::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Rebasing is a way to incorporate changes from one branch into another, but it rewrites history instead of creating a merge commit.
- Rebasing is an alternative to merging, and can be used to keep a feature branch up to date with the main branch.

::::::::::::::::::::::::::::::::::::::::::::::::

