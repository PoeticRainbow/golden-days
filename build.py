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

OPTIONS_DIR = "golden-days-options"
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


def main():
    print("Building Golden Days...")

    # clear previous build and reset for new build
    if os.path.isdir(OPTIONS_DIR):
        shutil.rmtree(OPTIONS_DIR, ignore_errors=True)
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


if __name__ == "__main__":
    main()
