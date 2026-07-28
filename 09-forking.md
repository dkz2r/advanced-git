---
title: "Forking Workflow"
teaching: 0
exercises: 0
---

::::::::::::::::::::::::::::::::::::::: objectives

- Use the forking workflow to contribute to a project.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- What are the common workflows of the forking branching model?

::::::::::::::::::::::::::::::::::::::::::::::::::

Preparation: Make sure that the main is clean, everything is committed.

The forking workflow is popular among open source software projects and often used in conjunction with a branching model.

The main advantage is that you enable people external to your project to implement and suggest changes to your project without the need to give them push access to your project.
In this workflow developers usually interact with multiple (at least two) repositories and remotes: the original code
repository and the forked repository.
It is important to understand that a fork represents a **complete copy** of a
remote repository.

In order to understand the forking workflow, let's first take a look at some special words and roles needed:

- **upstream** - Remote repository containing the "original copy"
- **origin** - Remote repository containing the forked copy
- **pull request (PR)** / **merge request (MR)** - Request to merge changes from fork to upstream (a request to add your suggestions to the "original copy")
- **maintainer** - Someone with write access to upstream who vets PRs/MRs
- **contributor** - Someone who contributes to upstream via PRs/MRs
- **release manager** - A maintainer who also oversees releases

In this workflow changes are suggested and integrated into the "upstream main" branch via a
pull/merge request from an "origin branch" (and not the "origin main").
The "origin main" branch is updated by pulling changes from the "upstream main"
as they become available.

This way the "upstream main" remains the true source for any suggested change
in the project, while allowing anyone to work on their own contributions independently.

::: callout
Pull requests / merge requests are a service of the hosting platform to ease
code reviews and managing changes. They only work **within the same hosting
service**, while you certainly have remotes on several hosting services
configured for a repository.
:::

![Forking Workflow](fig/forking_workflow.svg){alt="A diagram showing the forking workflow with upstream, origin, and local repositories."}


#### Example workflows

- [Example release workflow for the astropy Python package](https://docs.astropy.org/en/latest/development/maintainers/releasing.html)
- [Spacetelescope (STScI) style guide for release workflow](https://github.com/spacetelescope/style-guides/blob/master/guides/release-workflow.md)


## The main workflow

Once you discover a hosted Git project that you want to contribute to, you can
create a fork of this repository.

::: group-tab

### Github

![Screenshot of the button array in the top right corner of the Github interface with the fork button highlighted.](fig/github_fork_button.png){alt="A cropped screenshot of the Github UI showing the array of buttons on the top right of the project home page with the fork button highlighted."}

### Gitlab

![Screenshot of the button array in the top right corner of the Gitlab interface with the fork button highlighted.](fig/gitlab_fork_button.png){alt="A cropped screenshot of the Gitlab UI showing the array of buttons on the top right of the project home page with the fork button highlighted."}



:::

After clicking *fork* you can choose in which group you want to fork in. Only groups where you have write access will be listed.
Depending on the branching model of the upstream repository, you may want to copy only the `main` branch (or rather the branch set as the `default` branch).
For most repositories a full copy will be the best choice, especially if the upstream repository uses a more complex branching model.

#### Cloning the forked copy

After the fork is complete, you clone the repository as you would with any other personal project repository.
Your copy will then use the remote name *origin*.

On you cloned working copy you should then create a branch for your proposed changes.

::: caution
You should avoid changing the `main` branch of your local repository, as this should only be your reference to the upstream `main` branch, which eventually be providing updates (i.e., new commits). If you change your local `main` branch, its history will diverge from the upstream's history of the `main` branch causing problems in the future.
:::


#### Make changes and push branch to your fork

After you cloned the forked repository, you interact with it just the way you would with a repository of your own. In fact, the forked copy now *is* your own, as you have full access control over the forked project.
Remember to **only work on branches**.

#### Create a pull request

After pushing your branch onto your own fork, you can create a pull request in order to propose your modifications to the original repository. The maintainers of the project will review the changes and may ask for additional changes before merging them into the upstream repository.

::: challenge

## Exercise 1: Full fork-to-pull-request example

Complete the main *forking workflow* once for your project.

1. Fork a repository named by the workshop instructors.
2. Clone the repository
3. Create a new branch for the changes
3. Add and commit a change
4. Push branch to *origin* as the tracking branch

:::: solution
1. Fork the repository
2. Follow the clone-change-push workflow
```bash
git clone <repository-url>
git branch myfeature
git switch myfeature
# make changes
git add <changed-files>
git commit -m "Add feature X"
git push --set-upstream origin myfeature
```
3. Create a merge request to the **upstream** repository.
::::

:::


## Keeping up-to-date

You may either want to continue to contribute to the forked project, or the forked project has received updates before your changes could be merged.
Either way, you will want to incorporate the upstream changes into the corresponding branches both in the forked repository and your working copy.
For this it is best to add the original source, the *upstream* as a remote.
```bash
git remote add upstream <url-to-upstream-repository>
```

As you never modify the `main` branch, it remains straight forward to pull in any change from upstream.
First you switch to the main branch of your working copy, pull in changes directly from *upstream* `main`, and push them to your forked repository on *origin*.
```bash
git switch main
git pull upstream main
git push --set-upstream origin main
```

Updating your branch is a bit more intricate.
Here, we want our contributed changes to be the last on the branch, so we need to **rebase** the branch.
When we rebase the branch to the newest commits on `main`, the history of the *origin* `branch` and the *working copy* branch will have diverged and you will have to update the *origin* `branch` by force.

```bash
git switch mybranch
git pull --rebase upstream main
# resolve potential conflicts
git push --force origin mybranch
```

::: caution
Force-pushing to a remote branch will invalidate any other copies of that branch in other people's working copies.
This, it is usually a bad idea to force-push on branches actually worked on by others.
In that case, just merge the changes with `git pull upstream main` creating a merge commit.
:::

::: callout
The reason why some people prefer the *rebase* over the *merge* is that it keeps the history cleaner.The merge commits
It therefore remains a judgement call and will largely be influenced by the specific policies in place for the repositories of the projects you collaborate with.
:::

::: challenge

## Exercise 2: Keeping things up-to-date

Update the copies of your `main` branch after the successful merge of the pull request.

You can do this with the UI of the hosting service, but try to use the command line.

:::: solution
After the merge request is complete, you need to update your `main` branches from *upstream*
```bash
git switch main
git pull upstream main
git push --set-upstream origin main
```
::::
:::


:::::::::::::::::::::::::::::::::::::::: keypoints

- The forking workflow allows third parties to prepare and propose changes
  without write access to the upstream repository
- The `main` branch is not modified but only be updated from the upstream
  `main` branch
- Branch off `main` to a feature branch, pushing to the forked repository
  (origin)
- Update forked `main` branch using `git pull upstream main` where `upstream`
  is the name of the upstream remote
- Update your local feature branch by `git pull --rebase upstream main`
- Force push to origin branch for pull request updates.

::::::::::::::::::::::::::::::::::::::::::::::::::
