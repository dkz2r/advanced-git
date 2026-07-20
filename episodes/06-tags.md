---
title: "Tags"
teaching: 0
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- Learning about the `git tag` command

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can I flag a specific state of the project?

::::::::::::::::::::::::::::::::::::::::::::::::::

A tag is a marker of a specific commit in the project history. You can think of it as a permanent bookmark. Tags can be created to point to a release version, a major code change, a state of the code that was used to produce a paper or a data release, or any other event you (or the development team) may want to reference in the future.

Once a tag has been created, no other changes can be added to it. But you can delete it and create a new one with the same name.

Don't name your tags the same as your branches. Or the other way around. `git fetch` can get a tag or a branch and that can be confusing.

The command that allows you to handle git tags is just `git tag`. Without any flags it simply list the existing tags:

```bash
git tag
```

You can create a new tag based on the current state of the repository by providing a tag name to the `git tag` command:
```bash
git tag 1.0.0
```

This however creates what is called a `lightweight tag`. Lightweight tags are like a branch that doesn't change.

You can get information on a tag via `git show`:

```bash
git show 1.0.0
```

Lightweight tags are not recommended in most use cases because they do not save all the information. Instead, use `annotated tags` (https://git-scm.com/book/en/v2/Git-Basics-Tagging). They are stored as full objects in the Git database: they’re checksummed; contain the tagger name, email, and date; have a tagging message; and can be signed and verified with GNU Privacy Guard (GPG).

To create an annotated tag from the current commit:

```bash
git tag -a 2.0.0 -m <message>
```

It is also possible to tag a past commit by providing that commit's SHA:

```bash
git tag -a <tag> [<SHA>] -m <message>
```

To get more information about an existing tag you can "verify" it, which displays that tag's details, including the tagger, date, and message. This only works for annotated commits:

```bash
git tag -v 1.0.0    # this will fail
git tag -v 2.0.0
```

A tag allows you to switch to the version of the code that was tagged, to use that version of the code, or to see what the code looked at that tag. Here is how to check out a state of the code that has been tagged:

```bash
git checkout <tag>
```

Push a tag to origin:

```bash
git push origin <tag>
```

And of course you can delete a tag. This does not delete the commit, just removes the marker/label. Delete a tag:

```bash
git tag -d <tag>
```

Since tags are frequently used to do releases, it is useful to be aware that codebases and languages have standards on how release versions should be labelled. If you are working with an existing code base, follow the standard set by the dev team. If you are developing a library by yourself, follow the standards for the language. For example, the [Python Packaging Authority](https://packaging.python.org/en/latest/specifications/version-specifiers/#version-specifiers) (and previously [PEP440](https://peps.python.org/pep-0440/)) specifies the scheme for identifying versions for `python` libraries.

:::::::::::::::::::::::::::::::::::::::  challenge

## Tagging a Past Commit

We made many commits during the workshop. Inspect the commit history using `git log --oneline` and find the commit where we converted the guacamole recipe into a YAML format. Tag it with `3.0.0` with a suitable message. Then verify that the tag landed on the right commit using `git log --oneline --decorate`.

::: hint
You can tag a past commit by providing its SHA: `git tag -a <tag> [<SHA>] -m <message>`
:::

:::::::::::::::  solution

```bash
git log --oneline
```

```bash
git tag -a 0.1.0 <commit-hash> -m "Started Bread Recipes"

git log --oneline --decorate
```
```output
$ git log --oneline --decorate -n 10
3a8e5c5 (HEAD -> main, tag: 1.0.0, finish-pie-recipe) Add instructions to apple pie recipe.
ea212e8 Resolve merge conflict in salsa.md.
339cc33 Modify salsa instructions to include cilantro and lime juice.
4600586 (modify-salsa-instructions) Modify salsa instructions to include lime juice and salt.
9d204cb Merge salsa-instructions branch into main.
39725dd (pie-recipes) Add apple pie recipe
810f4e6 (salsa-instructions) Add instructions to salsa recipe.
e4f3d2a Add tomato soup recipe
6290ad8 (tag: 0.1.0) Add bread recipe templates
c0f9626 Add initial README with repository information
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge

## Challenge: Use a Tag to View the Repository at a Past State

Since tags are sort of like bookmarks, we can use them the same way we use hashes or relative references.

Using the tag we just made ("0.1.0"), what command would you use to see all changes that have been made to the repository since that tag was created? (i.e. the "diff" between the tag and the current state of the repository.)

What about getting a list of all commit messages that have been made since that tag was created?

::: hint

`git diff` can accept a tag name as an argument, just like it can accept a commit hash or a branch name.

:::

::: hint

`git log` can accept a tag name as an argument, but this only shows commits *until* that tag.

It can also accept a range of commits, using the form `git log <from>..<to>`...

:::

:::::::::::::::: solution

To view the changes made since the tag was created, you can use:

```bash
git diff 0.1.0
```

For a list of all commit messages since that tag was created, you can use:

```bash
git log 0.1.0..HEAD --oneline
```

:::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::: challenge

## Challenge: Detached HEAD state

We can use a tag to view the repository at a past state, however "checking out" a tag doesn't create a new branch, it puts us into a "detached HEAD" state.

Try the following command:

```bash
git checkout 0.1.0
```

1. Read the message that git prints to the terminal. What is the problem with being in a detached HEAD state?
2. What do you think it means to be in a detached HEAD state?
3. Do you see any changes in the console prompt? Try to make a commit. Do you notice anything different about the commit message?
4. Return to the main branch using `git checkout main`. What happens?


:::::::::::::::: solution

1. The message says that you are in a detached HEAD state, and that although you can make commits, they will be "lost" when you switch branches. This is because you are not truly on a branch, but rather on a specific commit (the one that the tag points to).
2. Being in a detached HEAD state means that the HEAD pointer (the current commit we are working on) is not pointing to a location on a branch, but rather to a specific commit. In a way, we are "off the tree" of our repository.
3. The console prompt may change to indicate that you are in a detached state - at the end of the prompt, in place of the branch name, you might see the tag or hash in double parentheses. When you make a commit, the commit message will be created as usual, but it will specifically state that it is on a detached HEAD.
4. When you return to the main branch using `git checkout main`, any commits you made in the detached HEAD state will not be part of the main branch. They will still exist in the repository, but they will be "orphaned" unless you create a new branch from them. Newer versions of git will provide a helpful message instructing you how to do this.

:::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::

<!--- ![Merging 1](../fig/14-tags.png)--->

:::::::::::::::::::::::::::::::::::::::: keypoints

- `git tag` allows us to mark a point we can return to.
- A tag is tied to a commit.

::::::::::::::::::::::::::::::::::::::::::::::::::
