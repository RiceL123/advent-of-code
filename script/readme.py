#!/usr/bin/env python3

import os
import json
import numpy as np
import matplotlib.pyplot as plt
from datetime import date
from collections import defaultdict

with open("./languages.json", "r") as f:
    languages = json.load(f)

extension_to_language = {
    ext: lang for lang, details in languages.items() for ext in details["extensions"]
}

parent_dir = os.path.join(os.pardir)
directories = [d for d in os.listdir(parent_dir) if d == str(date.today().year)]

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

    fig, ax = plt.subplots(subplot_kw=dict(projection="polar"))

    valsnorm = np.array(sizes) / 100 * 2 * np.pi
    valsleft = np.cumsum(np.append(0, valsnorm[:-1]))

    bars = ax.bar(x=valsleft, width=valsnorm, bottom=1-0.3, height=0.3, color=colors, linewidth=1, align="edge")

    legend_labels = labels
    plt.legend(
        bars,
        legend_labels,
        loc='center',
        bbox_to_anchor=(0.5, -0.07),
        ncol=4,
        frameon=True,
        fancybox=True,
        fontsize=8
    )
    
    ax.set_axis_off()
    fig.patch.set_facecolor('none')  

    height_in_inches = 300 / 96  
    aspect_ratio = 16 / 9  
    width_in_inches = height_in_inches * aspect_ratio
    fig.set_size_inches(width_in_inches, height_in_inches)

    output_file = f"{directory}.svg"
    plt.savefig(output_file, format='svg', transparent=True) 
    
    image_reference = f"![Languages Progress](script/{output_file})"
    image_references.append(f"### {directory}\n" + image_reference)
    print(f"Added image reference for {directory}: {image_reference}")

# readme_file = "../README.md"
# with open(readme_file, "r") as file:
#     readme_content = file.read()

# section_start = readme_content.find("## Languages")
# if section_start != -1:
#     section_end = len(readme_content)

#     updated_readme_content = (
#         readme_content[:section_start] +
#         "## Languages\n" +
#         "\n".join(sorted(image_references, reverse=True)) +
#         readme_content[section_end:]
#     )

# with open(readme_file, "w") as file:
#     file.write(updated_readme_content)

# print("README.md has been updated.")