#!/usr/bin/env python3

import glob, os, json, math
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

languages_info = json.load(open("./languages.json", "r"))
extension_to_language = {
    ext: (lang, details["color"])
    for lang, details in languages_info.items()
    for ext in details["extensions"]
}

class Language:
    def __init__(self, filepath):
        lang, color = extension_to_language.get(
            os.path.splitext(filepath)[1], "Unknown"
        )
        self.lang = lang
        self.size = os.path.getsize(filepath)
        self.color = color

def sortLanguages(file_glob) -> tuple[list[Language], int]:
    def hexToRGB(color: str):
        color = color[1:]  # ignore #prefix
        R = int(color[0:2], 16) / 255
        G = int(color[2:4], 16) / 255
        B = int(color[4:6], 16) / 255
        return R, G, B

    def getHue(color: str):
        R, G, B = hexToRGB(color)
        return math.atan2(math.sqrt(3) * (G - B), 2 * R - G - B)

    def getLuminance(color: str):
        R, G, B = hexToRGB(color)
        return 0.2126 * R + 0.7152 * G + 0.0722 * B

    def isChromatic(color: str):
        R, G, B = hexToRGB(color)
        return R != G or G != B

    languages = [Language(file_path) for file_path in glob.glob(file_glob)]
    darkest = min(filter(lambda x: isChromatic(x.color), languages), key=lambda x: getLuminance(x.color))
    langs = sorted(languages, key=lambda x: getHue(x.color) if isChromatic(x.color) else getHue(darkest.color) + 0.1)
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

    legend_labels = list(map(lambda x: f"{x.lang} {(x.size / size_total * 100):.1f}%", langs))
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
    directories = [d for d in os.listdir(parent_dir) if d == "2024"]

    for directory in directories:
        dir_path = os.path.join(parent_dir, directory)
        langs, size_total = sortLanguages(os.path.join(dir_path, "day*"))
        saveDoughnut(langs, size_total)
