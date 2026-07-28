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
git tag -a 3.0.0 <commit-hash> -m "Reformat recipe to use YAML"

git log --oneline --decorate
```
```output
<commit-hash> (HEAD -> main, tag: 3.0.0) Reformat recipe to use YAML
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::




<!--- ![Merging 1](../fig/14-tags.png)--->

:::::::::::::::::::::::::::::::::::::::: keypoints

- `git tag` allows us to mark a point we can return to.
- A tag is tied to a commit.

::::::::::::::::::::::::::::::::::::::::::::::::::
