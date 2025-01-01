#!/usr/bin/env python3

import os
import json
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from datetime import date
from collections import defaultdict

with open("./languages.json", "r") as f:
    languages = json.load(f)

extension_to_language = {ext: lang for lang, details in languages.items() for ext in details["extensions"]}

parent_dir = os.path.join(os.pardir)
directories = [d for d in os.listdir(parent_dir) if d == "2024"]

image_references = []

for directory in directories:
    dir_path = os.path.join(parent_dir, directory)

    language_sizes = defaultdict(int)

    for root, _, files in os.walk(dir_path):
        for file in files:
            file_path = os.path.join(root, file)
            if os.path.isfile(file_path):
                file_size = os.path.getsize(file_path)
                file_extension = f".{file.split('.')[-1]}"

                language = extension_to_language.get(file_extension, "Unknown")
                language_sizes[language] += file_size

    total_size = sum(language_sizes.values())
    if total_size == 0:
        print(f"No data found in directory: {directory}")
        continue

    languages_data = list(language_sizes.items())
    labels = [f"{lang} {size / total_size * 100:.1f}%" for lang, size in languages_data]
    sizes = [size / total_size * 100 for lang, size in languages_data]
    colors = [languages.get(language, {}).get("color", "#ededed") for language, _ in languages_data]

    fig = plt.figure(figsize=(16, 9), dpi=200)
    gs = gridspec.GridSpec(2, 1, height_ratios=[5, 1], hspace=0.2)

    ax = fig.add_subplot(gs[0], projection="polar")

    valsnorm = np.array(sizes) / 100 * 2 * np.pi
    valsleft = np.cumsum(np.append(0, valsnorm[:-1]))

    bars = ax.bar(
        x=valsleft,
        width=valsnorm,
        bottom=1 - 0.3,
        height=0.3,
        color=colors,
        align="edge",
    )
    ax.set_axis_off()

    legend_labels = labels
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

    image_reference = f"![Languages Progress](script/{output_file})"
    image_references.append(f"### {directory}\n" + image_reference)
    print(f"Added image reference for {directory}: {image_reference}")
