---
title: "Large Files"
teaching: 0
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- Understanding that Git is not intended for (large) binary files
- Learning about the `git lfs` commands
- Understanding the disadvantages of `git lfs`

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- Why are (large) binary files a problem in Git?
- What is Git LFS?
- What are the problems with Git LFS?

::::::::::::::::::::::::::::::::::::::::::::::::::

Sometimes, you might want to add non-textual data to your Git repositories.
Examples for such uses cases in a software project are e.g.

* assets for the project documentation like images
* test data for your test suite

However, such data is stored in binary formats most of the time. Git's line-based
approach of tracking changes is not suited for this type of data. While Git will
work with binary data without any errors, it will internally treat each binary file
as a file with one (very long) single line of content. Consequently, if you apply
changes to such a file, Git will store the entire file in the commit even if there
was a lot of similarity between the two versions of the file. As Git does not "forget"
about previous versions of the file, doing this repeatedly and/or with very large
files will quickly make your repository grow in size. At some point this will
severely impact the performance of all your Git operations from `git clone` to even
`git status`. **It is therefore generally discouraged to use Git to track (large) binary files.**

However, the problem of binary files in Git repositories cannot be fully neglected:
There is a lot of value for a software project in keeping things together that belong
together: Documentation assets belong to the documentation they are part of.
Therefore we will now explore some options on how to integrate large file handling into Git.

The `git lfs` subcommand is part of an extension to Git. LFS stands for **L**arge
**F**ile **S**torage. It allows you to mark individual files as being *large*.
Git does not apply its normal, line-based approach to tracking changes to these
large files, instead they are stored separately and only referenced in the Git data
model. During push and pull operations, large files are transmitted separately -
requiring the server to support this operation.

For the sake of demonstration, we create a file called `report.pdf`. We assume that it
is a large, binary file in order to show how to handle it with `git lfs`:

```bash
echo "This is a very large report." > report.pdf
```

First, we need to install LFS. This is something that should only be done once per machine.

```bash
git lfs install
```

Next, we tell Git, that this file should be treated with LFS:

```bash
git lfs track report.pdf
```

```
Tracking "report.pdf"
```

Having done so, we can inspect the repository and we learn that a new file `.gitattributes`
was added to the repository.

```bash
git status
```

```
On branch main

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	.gitattributes
	report.pdf
```

```bash
cat .gitattributes
```

```
report.pdf filter=lfs diff=lfs merge=lfs -text
```

Similar to `.gitignore` this file is part of the repository
itself in order to share it with all your collaborators on this project.
We therefore craft a commit that contains it:

```bash
git add .gitattributes
git commit -m "Setup LFS tracking"
```

Now, we are ready to add the large file to the repository the same way we would with any other file:

```bash
git add report.pdf
git commit -m "Add final report to the repository"
```

Pushing our commits to the remote repository, we can see in the console
output, that our LFS data was transferred to the remote server separately.

```bash
git push origin main
```

```
Uploading LFS objects: 100% (1/1), 17 B | 0 B/s, done.
```

::: callout

## Tracking with wildcard patterns

LFS tracking is not limited to explicitly spelled out filenames. Instead, wildcard
patterns can be passed to `git lfs track`. However, you should be careful to quote
these patterns, as they might otherwise get expanded by your shell.
For example, tracking all PDFs with LFS could be achieved with the following command:

```bash
git lfs track "*.pdf"
```

:::

::: caution

## Disadvantages of Git LFS

Although `git lfs` by design solves the problem of storing large files in Git
repositories, there are some practical hurdles that you should consider before
introducing LFS into your project:

* The `git lfs` command is a separately maintained extension to the Git core. It is
  therefore not part of most Git distributions, but needs to be installed separately.
  Using it in your project will require you to educate your users about LFS and how
  to install it. Depending on your target audience, you should carefully consider
  whether the benefits outweigh this disadvantage.
* Users that do not have `git lfs` installed will not be notified by Git. They
  will see the files, but the content will be Git metadata instead of the actual content.
  Trying to work with those files will typically produce cryptic error messages.
* Some hosting providers - most notably GitHub - apply restrictive quotas to LFS storage.
  On the free plan, GitHub currently allows 1GB of storage and 1 GB bandwidth per month.
  As the band width quota counts every single clone by users, **LFS should currently
  be considered unusable on the GitHub free plan.**

:::

:::::::::::::::::::::::::::::::::::::::: keypoints

- (Large) binary files can grow the repository size immensely and make it unusable
- `git lfs` is an extension that stores large files outside the Git data model
- Use of Git LFS is discouraged in many scenarios.

::::::::::::::::::::::::::::::::::::::::::::::::::
