---
title: ''
teaching: 10
exercises: 2
---

:::::::::::::::::::::::::::::::::::::: questions

- How can I avoid typing long commands in Git?
- How can I create a custom command in Git?

::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: objectives

- Create custom commands in Git using aliases.

::::::::::::::::::::::::::::::::::::::::::::::::

## Introduction

In this workshop we've introduced a number of Git commands, sometimes with long names and several options.
Some of them you might just memorize and rely on muscle memory to type out, but git also comes with a feature to create your own custom commands, called **aliases**.

### Why use aliases?

Aliases are a way to create your own custom commands in Git.
They can be used to shorten long commands, or to create new commands that combine several existing commands into one.

### Making an alias

Let's say you want to create an alias for the `git status` command, which is a command you use frequently. You can create an alias called `st` for this command by running:

```bash
git config alias.st status
```

Now, when you run `git st`, it will execute `git status`.
We can also create an alias for longer commands with options.
A command we've used frequently in this workshop is `git log --oneline --graph --all --decorate`, which shows a nice overview of the commit history.
We can create an alias for this command called `lg` by running:

```bash
git config alias.lg "log --oneline --graph --all --decorate"
```

after this, we can run `git lg` to see the same output as the longer command.

### Global vs. local aliases

So far our aliases have been created in the local repository, which means they will only be available in that repository.
However like the `git config` command, we can also create global aliases that will be available in all repositories on our system.
To create a global alias, we can use the `--global` option when creating the alias, for example:

```bash
git config --global alias.st status
git config --global alias.lg "log --oneline --graph --all --decorate"
```

You can view the aliases you've created by running `git config --get-regexp alias`, which will show all the aliases you've created in the current repository, or `git config --global --get-regexp alias` to see all the global aliases.
You can also run `git config --list` to see all the configuration options, including aliases, in the current repository, or `git config --global --list` to see all the global configuration options.

### Pros and Cons of using aliases

They can be very useful for shortening long commands, but they can also make it harder to remember the original command and its options.
It also can make it harder to transfer to a new system or to work with other people who may not have the same aliases set up.



::::::::::::::::::::::::::::::::::::: challenge

## Challenge: Create some aliases

Here are some ideas for commands you might create aliases for:

- `git log --oneline -n 5` as "git shortlog" (show the last 5 commits in a compact format)
- `git restore --staged .` as "git unstage" (unstage all changes that have been staged for the next commit)
- `git commit --amend --no-edit` as "git amend" (amend the last commit without changing the commit message)
- `git reset --soft HEAD~1` as "git undo" (undo the last commit, but keep the changes in the working directory)
- `git diff --staged` as "git staged" (show the changes that are staged for the next commit)
- `git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short` as "git fancylog" (show a nice overview of the commit history with a custom format)
- `git diff --name-only` as "git changed" (show only the names of the files that have changed)
- `git log --stat` as "git stat" (show a summary of the changes in each commit)
- `git config --get-regexp alias --global` as "git getalias" (show all the global aliases you've created)
- `git reset --hard && git clean -fd` as "git gtfo" (reset the working directory to the last commit and remove untracked files)

Try out the commands, and if you find one you like, create an alias for it.

:::::::::::::::: solution

There is no real solution for this challenge.

:::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: keypoints

- Aliases can save time and keystrokes when using Git commands frequently.

::::::::::::::::::::::::::::::::::::::::::::::::

