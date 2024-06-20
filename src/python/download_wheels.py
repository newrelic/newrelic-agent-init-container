# Copyright 2010 New Relic, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import shutil
import subprocess
import tempfile
from datetime import datetime

import requests

AGENT_VERSION = os.getenv("AGENT_VERSION", "").lstrip("v")
FILE_DIR = os.path.dirname(__file__)
WORKSPACE_DIR = os.path.join(FILE_DIR, "workspace")


def get_python_releases(package_info):
    releases = []
    for key, agent_version_details in package_info["releases"].items():
        if len(agent_version_details) > 0 and agent_version_details[0].get("upload_time", ""):
            upload_date = agent_version_details[0]["upload_time"].split("T")[0]
            upload_date = datetime.strptime(upload_date, "%Y-%m-%d")
            artifacts = [artifact["url"] for artifact in agent_version_details]
            releases.append({"version": key, "release_date": upload_date, "artifacts": artifacts})
    
    releases.sort(key=lambda x: x.get("release_date"))
    return releases


def main():
    """
    Download and unpack wheels and sdist for a given agent version as part of the build process for the Python agent init container.
    """
    with requests.session() as session:
        # Fetch JSON list of all agent package artifacts
        resp = session.get("https://pypi.org/pypi/newrelic/json")
        resp.raise_for_status()
        releases = get_python_releases(resp.json())

        if AGENT_VERSION:
            # Grab the supplied release version
            release = releases[AGENT_VERSION]
        else:
            # Grab latest release version
            release = releases[-1]

        # Filter artifacts for wheels and tarballs
        wheel_urls = [url for url in release["artifacts"] if url.endswith(".whl")]

        tarball_url = [url for url in release["artifacts"] if url.endswith(".tar.gz")][0]

        # Make workspace directory
        if not os.path.exists(WORKSPACE_DIR):
            os.mkdir(WORKSPACE_DIR)

        # Download tarball
        resp = session.get(tarball_url)
        resp.raise_for_status()

        tarball_filepath = os.path.join(WORKSPACE_DIR, "newrelic.tar.gz")
        with open(tarball_filepath, "wb") as file:
            file.write(resp.content)

        # Download and extract all wheels
        for wheel_url in wheel_urls:
            # Download wheel
            resp = session.get(wheel_url)
            resp.raise_for_status()

            # Write wheel to file under a folder of the same name
            with tempfile.TemporaryDirectory() as wheel_temp_dir:
                # Compute paths
                wheel_filename = wheel_url.split("/")[-1]
                wheel_filepath = os.path.join(wheel_temp_dir, wheel_filename)

                # Write wheel file to tempdir
                with open(wheel_filepath, "wb") as file:
                    file.write(resp.content)

                # Unpack wheel using wheel command
                subprocess.run(
                    ["wheel", "unpack", str(wheel_filename)],
                    cwd=wheel_temp_dir,
                )

                # Delete wheel file after unpacking
                os.remove(wheel_filepath)

                # Move unpacked module from tempdir to final destination
                unpacked_module_folder = os.path.join(
                    wheel_temp_dir, list(os.listdir(wheel_temp_dir))[0]
                )

                # Put wheel contents into folders named after the original wheel types
                final_wheel_dest = os.path.join(
                    WORKSPACE_DIR, wheel_filename.rstrip(".whl")
                )
                shutil.move(str(unpacked_module_folder), str(final_wheel_dest))


if __name__ == "__main__":
    main()
