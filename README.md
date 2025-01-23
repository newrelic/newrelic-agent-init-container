<a href="https://opensource.newrelic.com/oss-category/#community-project"><picture><source media="(prefers-color-scheme: dark)" srcset="https://github.com/newrelic/opensource-website/raw/main/src/images/categories/dark/Community_Project.png"><source media="(prefers-color-scheme: light)" srcset="https://github.com/newrelic/opensource-website/raw/main/src/images/categories/Community_Project.png"><img alt="New Relic Open Source community project banner." src="https://github.com/newrelic/opensource-website/raw/main/src/images/categories/Community_Project.png"></picture></a>

# New Relic Kubernetes Agent Operator Init Container Releases
This repository contains init containers and GHA workflows for automatically releasing new Kubernetes Agent Operator agent init containers when a new version of a language agent becomes available.

## Usage

Init containers published here are intended for use with the New Relic [Kubernetes Agents Operator](https://github.com/newrelic/k8s-agents-operator/). See the [Installation](https://github.com/newrelic/k8s-agents-operator/#installation) section for example use cases.

## Image Tagging Conventions

Agent versions at New Relic either follow [semver](https://semver.org/) (eg. `1.2.3`) or may contain an additional build number (eg. `1.2.3.99`). The example table below shows what Python Agent version would be pulled from various tags.

| Image Tag  | Agent Version                                                 |
|------------|---------------------------------------------------------------|
| `latest`   | The latest agent release                                      |
| `9`        | The latest `9.*` release                                      |
| `9.10`     | The latest `9.10.*` release                                   |
| `9.10.0`   | The latest **init container build** of agent version `9.10.0`  |
| `9.10.0.0` | The initial **init container build** of agent version `9.10.0` |

In this example, once the tag `9.10.0.0` is published it will never be replaced. If a rebuilt container for agent version `v9.10.0` is released, it will be published as `9.10.0.1`, incrementing the init container build number.

### Node.js

Each Node.js container is only compatible with a single major version of Node.js. As a result, all Node.js agent versions are published as separate images with a Node.js version suffix. The `latest` tag and any tags without this suffix point to the latest supported major version of Node.js. For example:

| Image Tag         | Node.js Major Version   |
|-------------------|------------------------|
| latest            | Latest Supported  (20) |
| 11.19.0           | Latest Supported  (20) |
| 11.19.0-nodejs20x | 20                     |
| 11.19.0-nodejs18x | 18                     |
| 11.19.0-nodejs16x | 16                     |

## Local Testing

Under the `tests/` folder, there is a Makefile for local building and testing of init container images.

### Prerequisites

1. [Docker](https://docs.docker.com/)
2. [minikube](https://minikube.sigs.k8s.io/docs/)
3. [Helm](https://helm.sh/)
4. [GNU Make](https://www.gnu.org/software/make/)

### Quickstart

1. Specify environment variables with the language of the init container you wish to build locally, and your [New Relic License Key](https://docs.newrelic.com/docs/apis/intro-apis/new-relic-api-keys/).
```bash
export INITCONTAINER_LANGUAGE=python
export NEW_RELIC_LICENSE_KEY=***
```
2. On the first test run, start the minikube cluster and all dependencies, and build the test app. A browser window will open if the deployment succeeds.
```bash
make -f tests/Makefile all
```
3. On subsequent runs, rebuild just the init container and test app. A browser window will open if the deployment succeeds.
```bash
make -f tests/Makefile test
```

### Step by Step

1. Specify environment variables with the language of the init container you wish to build locally, and your [New Relic License Key](https://docs.newrelic.com/docs/apis/intro-apis/new-relic-api-keys/).
```bash
export INITCONTAINER_LANGUAGE=python
export NEW_RELIC_LICENSE_KEY=***
```
2. Start a minikube cluster for local testing:
```bash
make -f tests/Makefile minikube
```
3. Install the New Relic [Kubernetes Agents Operator](https://github.com/newrelic/k8s-agents-operator/)
```bash
make -f tests/Makefile operator
```
4. Build a local copy of the init container in minikube.
```bash
make -f tests/Makefile build-initcontainer
```
5. Build a local copy of the test app in minikube.
```bash
make -f tests/Makefile build-testapp
```
6. Deploy the test app instrumented with the init container. A browser window will open if the deployment succeeds.
```bash
make -f tests/Makefile test
```

## Releasing Old Versions

To release one or more old versions of the agent, follow these steps.

1. Start with the **oldest** agent version that must be re-released. **Do not publish another agent version until the previous one is available on Docker Hub, or tags may be overwritten.**
2. Navigate to the [releases](https://github.com/newrelic/newrelic-agent-init-container/releases) page and draft a new release.
3. Decide on a new version number, which should be the agent version with an extra init container build number at the end. If `.0` of the init container has already been released do **NOT** rerelease that version and instead increment it to `.1` (or higher).
4. Create a new tag from main with the format `v<AGENT_VERSION>.<INITCONTAINER_BUILD_NUMBER>_<LANGUAGE>` (eg. `v9.11.0.1_python` for the second build of Python Agent version `v9.11.0`).
5. Name the release `New Relic <LANGUAGE> Agent v<AGENT_VERSION>.<INITCONTAINER_BUILD_NUMBER>` (eg. `New Relic Python Agent v9.11.0.1`).
6. Publish the release, and wait for the GitHub Action workflow to publish the image to Docker Hub.

If the batch of old versions does not republish **every** agent version between the start of the batch and the newest agent version available on Docker Hub, then tags must be adjusted to fix conflicts.

7. Adjust the `latest` tag and any existing tags that overlap with the published image. (See [Fixing Docker Image Tags](#fixing-docker-image-tags) and the [example](#example) below.)

## Fixing Docker Image Tags

1. Install Google's [crane](https://github.com/google/go-containerregistry/tree/main/cmd/crane) CLI tool.
```bash
brew install crane
```
2. Identify any tags that should be replaced (eg. `latest` should point to `v9.11.0.0` but does not).
3. Use `crane copy` to "copy" an existing tagged image to another tag. 
```bash
export IMAGE_NAME=newrelic/newrelic-python-init
crane copy $IMAGE_NAME:9.11.0.0 $IMAGE_NAME:latest
```

*Note: This process overwrites an existing tag, correctly handling multi-architecture images, and does so without pulling images. It simply adjusts the manifests in Docker Hub which is significantly faster and safer than attempting to create new multi-architecture manifests by hand.*

### Example

Republishing Python Agent `v8.10.0` as init container `8.10.0.1` when `v8.10.1` through `v9.11.0` are already published will overwrite the tags `latest`, `8` and `8.10`. These tags should be corrected to point to the following: 

* `latest` -> `v9.11.0`, the newest agent version.
* `8` -> `v8.11.0`, the newest `8.*` version.
* `8.10` -> `v8.10.1`, the newest `8.10.*` version.

As a result, the following commands are run.

```bash
export IMAGE_NAME=newrelic/newrelic-python-init
crane copy $IMAGE_NAME:9.11.0.0 $IMAGE_NAME:latest
crane copy $IMAGE_NAME:8.11.0.0 $IMAGE_NAME:8
crane copy $IMAGE_NAME:8.10.1.0 $IMAGE_NAME:8.10
```

For agents with suffixes like `-nodejs20x`, significantly more tags will need to be overwritten (see [image tagging conventions](#image-tagging-conventions)).

## Support

New Relic hosts and moderates an online forum where you can interact with New Relic employees as well as other customers to get help and share best practices. Like all official New Relic open source projects, there's a related Community topic in the New Relic Explorers Hub. You can find this project's topic/threads here:

https://forum.newrelic.com/s/

## Contribute

We encourage your contributions to improve New Relic Kubernetes Agent Operator Init Container Releases! Keep in mind that when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.

If you have any questions, or to execute our corporate CLA (which is required if your contribution is on behalf of a company), drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [our bug bounty program](https://docs.newrelic.com/docs/security/security-privacy/information-security/report-security-vulnerabilities/).

If you would like to contribute to this project, review [these guidelines](./CONTRIBUTING.md).

To all contributors, we thank you!  Without your contribution, this project would not be what it is today.

## License
New Relic Kubernetes Agent Operator Init Container Releases is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.
The New Relic Kubernetes Agent Operator Init Container Releases also uses source code from third-party libraries. You can find full details on which libraries are used and the terms under which they are licensed in the third-party notices document.
