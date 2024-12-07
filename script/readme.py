#!/usr/bin/env python3

import os
import json
from collections import defaultdict

with open("languages.json", "r") as f:
    languages = json.load(f)

extension_to_language = {
    ext: lang for lang, details in languages.items() for ext in details["extensions"]
}

parent_dir = os.path.join(os.pardir)
directories = [d for d in os.listdir(parent_dir) if d.isdigit() and len(d) == 4]

html_template = ""

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

    # Title
    html_template += f'<h3>{directory}</h3>\n'

    # Progress Bar
    html_template += '<div><span style="display: flex; height: 12px; overflow: hidden; background-color: #e1e4e8; border-radius: 10px; box-shadow: inset 0 -1px 0 rgba(27,31,35,.12);">\n'
    html_template += '\n'.join([
        f'<span style="background-color:{languages.get(language, {}).get("color", "#ededed")} !important;width: {((size / total_size) * 100):.1f}%;" aria-label="{language} {((size / total_size) * 100):.1f}%" style="height: 100%;"></span>'
        for language, size in language_sizes.items()
    ])
    html_template += '\n</span></div>\n'

    # Languages
    html_template += '<ul style="display: flex; list-style: none; padding: 0;">\n'
    html_template += "\n".join([
        f'<li style="display: inline-block; margin-right: 1em"><span style="display: flex; gap: 0.3em; align-items: center;"><span style="color:{languages.get(language, {}).get("color", "#ededed")}; font-size: 2em; font-weight: 900;">•</span><span style="font-weight: bold">{language}</span><span>{((size / total_size) * 100):.1f}%</span></span></li>'
        for language, size in language_sizes.items()
    ])
    html_template += '</ul>\n'

readme_file = "../README.md"

with open(readme_file, "r") as file:
    readme_content = file.read()

section_start = readme_content.find("## Languages")
if section_start != -1:
    section_end = readme_content.find("##", section_start + 1)
    if section_end == -1:
        section_end = len(readme_content)
    
    # Replace the entire section under "## Languages"
    updated_readme_content = (
        readme_content[:section_start] +
        "## Languages\n" + html_template +
        readme_content[section_end:]
)

with open(readme_file, "w") as file:
    file.write(updated_readme_content)