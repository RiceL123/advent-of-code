#!/usr/bin/env python3

import glob, os, json, math
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec


import requests
import yaml


LANGUAGES_YML_URL = "https://raw.githubusercontent.com/github-linguist/linguist/refs/heads/main/lib/linguist/languages.yml"


def load_languages_data(url: str):
    """Fetches and parses the languages.yml file from the given URL."""
    print(f"Fetching language data from {url}...")
    try:
        response = requests.get(url)
        response.raise_for_status()
        return yaml.safe_load(response.text)
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")

        raise
    except yaml.YAMLError as e:
        print(f"Error parsing YAML data: {e}")
        raise


languages_info = load_languages_data(LANGUAGES_YML_URL)

extension_to_language = {}
for lang, details in languages_info.items():
    color = details.get("color", "#CCCCCC")

    if details.get("type") == "data":
        continue

    extensions = details.get("extensions", [])
    for ext in extensions:
        extension_to_language[ext] = (lang, color)

DEFAULT_LANG_COLOR = "#AAAAAA"


class Language:
    def __init__(self, filepath):

        lang, color = extension_to_language.get(
            os.path.splitext(filepath)[1], ("Unknown", DEFAULT_LANG_COLOR)
        )
        self.lang = lang
        self.size = os.path.getsize(filepath)
        self.color = color


def sortLanguages(file_glob) -> tuple[list[Language], int]:
    def hexToRGB(color: str):

        if not color or not isinstance(color, str) or not color.startswith("#"):
            color = DEFAULT_LANG_COLOR
        color = color[1:]
        R = int(color[0:2], 16) / 255
        G = int(color[2:4], 16) / 255
        B = int(color[4:6], 16) / 255
        return R, G, B

    def getHue(color: str):
        R, G, B = hexToRGB(color)
        epsilon = 1e-6
        return math.atan2(math.sqrt(3) * (G - B), 2 * R - G - B + epsilon)

    def getLuminance(color: str):
        R, G, B = hexToRGB(color)
        return 0.2126 * R + 0.7152 * G + 0.0722 * B

    def isChromatic(color: str):
        R, G, B = hexToRGB(color)
        return R != G or G != B

    languages = [Language(file_path) for file_path in glob.glob(file_glob)]

    aggregated_sizes = {}

    for lang_obj in languages:
        key = (lang_obj.lang, lang_obj.color)
        aggregated_sizes[key] = aggregated_sizes.get(key, 0) + lang_obj.size

    aggregated_langs = []
    for (lang, color), size in aggregated_sizes.items():

        temp_lang_obj = Language(os.devnull)
        temp_lang_obj.lang = lang
        temp_lang_obj.color = color
        temp_lang_obj.size = size
        aggregated_langs.append(temp_lang_obj)

    languages = aggregated_langs

    valid_colored_langs = list(
        filter(lambda x: x.color != DEFAULT_LANG_COLOR, languages)
    )

    class DummyDarkest:
        def __init__(self, color):
            self.color = color
            self.lang = "Dummy"
            self.size = 0

    fallback_darkest = DummyDarkest(DEFAULT_LANG_COLOR)

    chromatic_langs = list(filter(lambda x: isChromatic(x.color), valid_colored_langs))

    if chromatic_langs:
        darkest = min(chromatic_langs, key=lambda x: getLuminance(x.color))
    elif valid_colored_langs:
        darkest = min(valid_colored_langs, key=lambda x: getLuminance(x.color))
    else:
        darkest = fallback_darkest

    base_hue = (
        getHue(darkest.color)
        if isChromatic(darkest.color)
        else getHue(DEFAULT_LANG_COLOR)
    )

    langs = sorted(
        languages,
        key=lambda x: getHue(x.color) if isChromatic(x.color) else base_hue + 0.1,
    )

    size_total = sum([x.size for x in langs])
    return langs, size_total


def saveDoughnut(langs: list[Language], size_total):
    fig = plt.figure(figsize=(16, 9), dpi=200)
    gs = gridspec.GridSpec(2, 1, height_ratios=[5, 1], hspace=0.2)
    ax = fig.add_subplot(gs[0], projection="polar")

    valsnorm = np.array(list(map(lambda x: x.size / size_total, langs))) * 2 * np.pi
    valsleft = np.cumsum(np.append(0, valsnorm[:-1]))

    bars = ax.bar(
        x=valsleft,
        width=valsnorm,
        bottom=1 - 0.3,
        height=0.3,
        color=list(map(lambda x: x.color, langs)),
        align="edge",
    )
    ax.set_axis_off()

    legend_labels = list(
        map(lambda x: f"{x.lang} {(x.size / size_total * 100):.1f}%", langs)
    )
    legend_ax = fig.add_subplot(gs[1])
    legend_ax.axis("off")
    legend_ax.legend(
        bars,
        legend_labels,
        loc="center",
        bbox_to_anchor=(0.5, 0.5),
        ncol=5,
        frameon=True,
        fancybox=True,
        fontsize=8,
    )

    height_in_inches = 320 / 96
    aspect_ratio = 18 / 9
    width_in_inches = height_in_inches * aspect_ratio
    fig.set_size_inches(width_in_inches, height_in_inches)

    output_file = f"{directory}.svg"
    plt.savefig(output_file, format="svg", transparent=True)


if __name__ == "__main__":

    parent_dir = os.path.join(os.pardir)
    directories = [d for d in os.listdir(parent_dir) if d == "2025"]

    for directory in directories:
        dir_path = os.path.join(parent_dir, directory)
        langs, size_total = sortLanguages(os.path.join(dir_path, "day*"))

        langs = [lang for lang in langs if lang.size > 0]
        size_total = sum([x.size for x in langs])
        if size_total > 0:
            saveDoughnut(langs, size_total)
        else:
            print(f"Skipping {directory}: No files with size > 0 found.")
