"""
Golden Days Build Script
All Rights Reserved
Copyright PoeticRainbow
Contact for permissions
"""

import os
import glob
import json
import shutil
import re

ARTIFACT_DIR = "artifacts"
OPTIONS_DIR = os.path.join(ARTIFACT_DIR, "golden-days-options")
PREFIX = "option_"


def make_description(name: str):
    return f"§6Golden Days §8- §3Option\n§b{name}"


def load_json(path: str) -> dict:
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def write_json(dict: dict, path: str):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(dict, f, ensure_ascii=False)

def create_standalone_option(root: str, option: str, pack_mcmeta: dict):
    no_prefix = option.replace(PREFIX, "")
    if "mod" in no_prefix:
        no_prefix = re.sub(r"mod_[a-z]+_", "", no_prefix)
    path = os.path.join(OPTIONS_DIR, "golden-option-" + no_prefix.replace("_", "-"))  # new path/working path
    name = no_prefix.replace("_", " ").title()
    print(f"Creating option {name} at {path}")
    # copy overlay over to working directory
    shutil.copytree(os.path.join(root, option), path)
    # copy pack.png
    overlay_pack_png = os.path.join(path, "pack.png")
    if not os.path.isfile(overlay_pack_png):
        # if there was not a pack.png in the overlay, copy the one from the base pack
        shutil.copy(os.path.join(root, "pack.png"), overlay_pack_png)
    # create a copy of the og pack mcmeta and replace the description
    # with one that describes the given option
    option_mcmeta = {"pack": pack_mcmeta["pack"].copy()}
    option_mcmeta["pack"]["description"] = make_description(name)
    option_mcmeta_path = os.path.join(path, "pack.mcmeta")
    write_json(option_mcmeta, option_mcmeta_path)


def build_golden_days_tweaks():
    base = "golden-days-base"
    root = "golden-days-tweaks"
    working_dir = os.path.join(ARTIFACT_DIR, "golden-days-tweaks")
    # copy all wanted files from base pack into working dir
    include = []
    with open(os.path.join(root, "include.txt"), encoding="utf-8") as f:
        include = [x.strip() for x in f.read().splitlines() if x and not x.startswith("#")]
    copy_count = 0
    for path in include:
        for src_path in glob.glob(os.path.join(base, path), recursive=True):
            if os.path.isfile(src_path):
                dst_path = os.path.join(working_dir, os.path.relpath(src_path, base))
                os.makedirs(os.path.dirname(dst_path), exist_ok=True)
                shutil.copy(src_path, dst_path)
                copy_count += 1
    print(f"Copied {copy_count} files from {base} to {working_dir}")
    # copy and replace files from tweak pack into working dir
    shutil.copytree(root, working_dir, dirs_exist_ok=True)

def main():
    print("Building Golden Days...")

    # clear previous build and reset for new build
    if os.path.isdir(ARTIFACT_DIR):
        shutil.rmtree(ARTIFACT_DIR, ignore_errors=True)
    os.makedirs(OPTIONS_DIR, exist_ok=True)

    # loop through each pack
    for pack in glob.glob("golden-days-*"):
        # load the pack.mcmeta from the given pack
        pack_mcmeta_path = os.path.join(pack, "pack.mcmeta")
        if not os.path.exists(pack_mcmeta_path):
            # skip if there is no pack.mcmeta
            continue
        pack_mcmeta = load_json(pack_mcmeta_path)
        if "overlays" in pack_mcmeta:
            # collect every optional overlay from every pack
            for option in glob.glob(f"*{PREFIX}*", root_dir=pack):
                create_standalone_option(pack, option, pack_mcmeta)

    # copies files from the base pack that control sounds, removing particles, etc
    # intended for use overtop of existing resource packs
    build_golden_days_tweaks()


if __name__ == "__main__":
    main()
