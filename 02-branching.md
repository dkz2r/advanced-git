---
title: "Branches"
teaching: 0
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- Understand how branches are created.
- Learn the key commands to view and manipulate branches.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- What are branches?
- How do I view the current branches?
- How do I manipulate branches?

::::::::::::::::::::::::::::::::::::::::::::::::::

Branching is a feature available in most modern version control systems. Branching in other version control systems can be an expensive operation in both time and disk space.
In `git`, branches are a part of your everyday development process. When you want to add a new feature or fix a bug—no matter how big or how small—you spawn a new branch to encapsulate your changes.
This makes it harder for unstable code to get merged into the main code base, and it gives you the chance to clean up your future's history before merging it into the main branch.
It also reduces the difficulties inherent in collaborating with others, as you can work on your own branch without affecting anyone else's work, meaning that merge conflicts only have to be resolved when you are ready to merge your changes into the main branch.

![Git Branching: An example of how branches of a repository are based on each other and evolve over time. (Source: [Atlassian Git Tutorial](https://www.atlassian.com/git/tutorials/using-branches))](fig/03-branching-example.png){alt="A diagram showing branching in a theoretical git repository."}

The diagram above visualizes a repository with two isolated lines of development, one for a little feature, and one for a longer-running feature.
By developing them in branches, it’s not only possible to work on both of them in parallel, but it also keeps the main branch free from questionable code.

::: callout

Note that the point at which each branch diverges from the main branch is different. Branches can be created at any point in the history of a repository, and they can be merged back into the main branch at any time.

:::

The implementation behind Git branches is much more lightweight than other version control system models.
Instead of copying files from directory to directory, Git stores a branch as a reference to a commit.
In this sense, a branch represents the tip of a series of commits - it's not a container for commits.
The history for a branch is extrapolated through the commit relationships.

## What is a branch?

In `git` a branch is effectively a pointer to a snapshot of your changes.
It's important to understand that branches are just pointers to commits.
When you create a branch, all Git needs to do is create a new pointer, it doesn't change the repository in any other way.

Let's say you start with a repository that looks like this:

![Git Branching: A branch is just a "named pointer" to a commit.  (Source: [Atlassian Git Tutorial](https://www.atlassian.com/git/tutorials/using-branches))](fig/04-branching.png){alt="A diagram showing several commits on a single branch in a theoretical git repository."}

Now we have an idea that we want to try out.
We're not convinced that this will work, and we don't want to risk breaking the main branch, so we create a new branch at the current commit:

```bash
git branch <branch-name>
```

The repository history remains unchanged. All you get is a new pointer to the current commit:

![Git Branching: The new branch is pointing to the same commit from which it was branched off. (Source: [Atlassian Git Tutorial](https://www.atlassian.com/git/tutorials/using-branches))](fig/05-branching.png){alt="A diagram showing a new branch pointer in a theoretical git repository."}

::: callout

Note that this only creates the new branch.
To start adding commits to it, you need to move to it with `git checkout`, and then use the standard `git add` and `git commit` commands.

:::

A branch *also* means an independent line of development.
Branches serve as an abstraction for the edit/stage/commit process.
New commits are recorded in the history for the current branch, which results in a fork in the history of the project.
However, it is really important to remember that each commit only records the incremental change in the document and NOT the full history of changes.
Therefore, while we think of a branch as a sequence of commits, each commit is an independent unit of change.

### Making a Branch in our Repository

Returning to our recipe repository, we have an idea - so far we've been storing the recipes in Markdown format, but we've heard of YAML format and think it might be a better format for storing our recipes.
We'll create a new branch to experiment with this idea, and we'll call it `yaml`:

```bash
git branch yaml
```

If we run `git branch` again without the branch name, we get a list of all of the branches in our local repository.
We can see that we now have two branches:

```bash
git branch
```

```output
$ git branch
* main
  yaml
```

The asterisk (`*`) indicates the current branch.

::: callout

Depending on your repository, you may see other branches in this list.

:::

To see more information about each branch, including the latest commit on each branch, use the `-avv` flags:

```bash
git branch -avv
```
```output
$ git branch -avv
* main                    670e331 Add guacamole recipe
  yaml                    670e331 Add guacamole recipe
```

We can see that, as we have not added any new commits to the `yaml-format` branch, both branches point to the same commit (`670e331`).

## Branching Commands

On second thought, we don't like that branch name. Let's rename it to `yaml-format` instead.
We can do this with the `-m` flag on the `git branch` command, specifying the old name and the new name:

```bash
git branch -m yaml yaml-format
```

::: callout

Note that renaming the branch does remove the old branch - it does not make a copy of it.
The commit history will remain intact.

:::

At the moment, however, note that we are still on the `main` branch.
The "branch" command only creates a new pointer to the current commit, it does not switch to that branch.
To switch we need to use the `git switch` command:

```bash
git switch yaml-format
```

::: callout

`git switch` was introduced in Git 2.23 as a more purpose specific command for switching branches.
It is functionally similar to `git checkout`, which is still used widely, but is a more general
command with multiple purposes (switching branches, restoring files, etc).

Older tutorials may use the `git checkout` command to switch branches, but this command has been deprecated in favor of `git switch`.
There's nothing wrong with using `git checkout` to switch branches, but it is recommended to use `git switch` instead, especially for new users.

```bash
git switch -c <new> <start-point>
```

:::


Let's switch over to our new branch so we can start making changes:

```bash
git switch yaml-format
```

```output
$ git switch yaml-format
Switched to branch 'yaml-format'
```

Let's reformat our recipe to use YAML and commit the changes:

```bash
nano guacamole.md
```

```
name: Guacamole
ingredients:
  avocado: 1.35
  lime: 0.64
  salt: 2
instructions: ""
```

```bash
git add guacamole.md
git commit -m "Reformat recipe to use YAML."
```

Now let's check our branches again:

```bash
git branch -avv
```

```output
$ git branch -avv
  main        670e331 Add guacamole recipe
* yaml-format ff3d232 Reformat recipe to use YAML.
```

## Changes stay on the branch

We've made a new commit, but this commit is only on the `yaml-format` branch.
We can always switch back to the `main` branch and see that the changes we made on the `yaml-format` branch are not present there:

```bash
git switch main
cat guacamole.md
```


::: spoiler

**Quick Reference: Branching Commands**

To create a new branch named `<branch>`, which *references the same point in history as the current branch.*
```bash
git branch <branch>
```

To create a new branch named `<branch>`, referencing `<start-point>`, which may be specified any way you like, including using a branch name or a tag name:

```bash
git branch <branch> <start-point>
```

To delete the branch `<branch>`; if the branch is not fully merged in its upstream branch or contained in the current branch, this command will fail with a warning:
```bash
git branch -d <branch>
```

To delete the branch `<branch>` irrespective of its merged status:
```bash
git branch -D <branch>
```

Renaming a branch can be done with the `-m` tag:
```bash
git branch -m <old-branch-name> <new-branch-name>
```

:::

:::::::::::::::::::::::::::::::::::::::  challenge

Challenge 1: Renaming a file in a branch

We updated our guacamole recipe in the `yaml-format` branch to use a different format.
But now the file extension `.md` doesn't make sense anymore.

Switch back to the `yaml-format` branch, rename the file to `guacamole.yaml` and commit the change to the `yaml-format` branch.
Run `git status` before you commit your changes.
Is there anything different about the way this commit looks than in our earlier exercises?

::: hint

You can use the `mv` command to rename files in the terminal:

```bash
mv old-filename new-filename
```

:::

:::::::::::::::  solution

```bash
mv guacamole.md guacamole.yaml
git add guacamole.yaml guacamole.md
git status
```

```output
$ git status
On branch yaml-format
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        renamed:    guacamole.md -> guacamole.yaml
```

Git is not very clever about most things, but as long as the contents of the file are identical, it
can at least figure out that we just renamed the file, rather than deleting one and adding another.

```bash
git commit -m "Rename recipe file to use .yaml extension."
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

Challenge 2: Renaming a branch
You realize the branch name `yaml-format` is not descriptive enough. Rename it to `feature/yaml-format` without losing any of your work.

::: hint

You can check the documentation of git branch with `git branch --help`

:::

:::::::::::::::  solution
```bash
git branch -m yaml-format feature/yaml-format
git branch
```
```output
* feature/yaml-format
  main
```

The `-m` flag changes the name of the branch without removing it, so the whole commit history remains intact.

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

Challenge 3: Deleting an Unmerged Branch

We think about adding new dessert recipes to our recipe collection.
To avoid affecting the main branch we need to create a new branch named dessert-recipes and switch to this branch.

Run the following commands to create the branch, switch to it, and add a new recipe for cookies:

```bash
git branch dessert-recipes
git switch dessert-recipes
echo "# Chocolate Chip Cookies\n## Ingredients\n ## Instructions" > cookies.md
git add cookies.md
git commit -m "Add chocolate chip cookies recipe."
```

After that, we create a simple cookie recipe with the name cookies.md and commit it.

Later we decide that it’s not the right time to start with the dessert recipes and cookies and we don’t want the cookie recipe to remain in our repository.

What happens when we use git branch -d?
Why does git react this way and how can we force the deletion?

::: hint
Think about how you checked the documentation in the previous challenge.
:::

:::::::::::::::  solution
```bash
git switch -c dessert-recipes
nano cookies.md

(add recipe content)

git add cookies.md
git commit -m "Add chocolate chip cookies recipe."
git switch main

git branch -d dessert-recipes
```
```output
$ git branch -d dessert-recipes
error: the branch 'dessert-recipes' is not fully merged
hint: If you are sure you want to delete it, run 'git branch -D dessert-recipes'
```

Git uses `-d` as a safety net - it will not delete a branch that has not been merged into the current branch, as that would mean losing commits that exist nowhere else.
`-D` bypasses this check and deletes the branch even if it is not merged.

```bash
git branch -D dessert-recipes
```

```output
Deleted branch dessert-recipes (was <commit-hash>).
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: keypoints

- A branch represents an independent line of development.
- `git branch` creates a new pointer to the current state of the repository and allows you to make subsequent changes from that state.
- Subsequent changes are considered to belong to that branch.
- The final commit on a given branch is its HEAD.

::::::::::::::::::::::::::::::::::::::::::::::::::
