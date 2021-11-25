# web3auth metarepo

This is the metarepo for CNE's web3auth projects that contains all of the repos that make up the project and example website, as well as a local development cluster to run it all in, as well as scripts to set it all up for you.

A meta repo is just a JSON file that describes what repos make up the overall project - see `.meta`

Every project inside the meta repo is a regular, plain old git repository.

## Prerequisites

The projects contained within use many tools.

### onboard.sh

> WARNING: this will change settings on your computer and install things, read the script before running it!

To install all of the required tools, see the [Onboard Repo](https://github.com/cloudnativeentrepreneur/onboard), which contains a script for installing and configuring all of the tools used in the project.

You can also choose to just look through the `onboard.sh` script in that repo and install just the tools you need by copying and pasting relevant sections.

## meta git clone

To clone all of the repositories that make up web3auth projects, run:

```
npx meta git clone git@github.com:CloudNativeEntrepreneur/web3auth-meta.git
```

## getting updates

This step describes how to get updates, if this is your first run, go ahead and move on to the next section.

If you've `meta git clone`d the repo in the past and new repos were added to the `.meta` file since then, you can `update` the meta repo with new repositories with the following:

#### 1. get latest master of meta repo
```
git checkout master
git fetch --all --tags -p
git rebase origin/master
```

#### 2. Then, to clone any missing repos from the meta repo to your machine, run:

```
npx meta git update
```

or 

```
meta git update
```

if you've installed `meta` globally

#### 3. Then to get on the latest version of `master` for each project in the .meta JSON file, you can run:

```
npx meta exec "git fetch && git rebase origin/master --autostash"
```

or 

```
meta exec "git fetch && git rebase origin/master --autostash"
```

if you've installed `meta` globally

## make onboard

To start working with the project, after installing prerequisite tools, and meta git cloning this meta repo, run the command `make onboard`. This will set up and connect you to a local Kubernetes cluster for development, configure that cluster with cluster tooling required to run all of the pieces, and deploy each of the projects to the cluster.

```
make onboard
```

> WARNING: If you are managing multiple Kubernetes clusters on your local machine, this command will change your Kubernetes context!! Make sure you are aware of this, and switch to and from other clusters accordingly!

## Local Development Cluster

A cluster was started via Kind via the `make onboard` command. Each time you start up Docker, this cluster will start up until you delete it.

### Refresh Local Images

To refresh the images running on your local cluster, run:

```
make refresh-local-images
```

To see the available services run `kubectl get ksvc`.

### localizer (optional)

Localizer eases development with Kubernetes by managing tunnels and host aliases to your connected Kubernetes cluster. This way, instead of port-forwarding tools like databases to use them, you can just use their internal network address: `http://${serviceName}.${namespace}.svc.cluster.local`.

To start developing with your local cluster, first, start `localizer` in a new terminal window with:

```
make localizer
```

Leave this terminal running while you are working with the local cluster.
