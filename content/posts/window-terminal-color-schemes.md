---
title: "Window Terminal Color Schemes"
date: 2025-01-01T20:28:36+08:00
draft: false
showtoc: true
math: false
tags: []
---

1. Clone the repository

```sh
git clone git@github.com:mbadolato/iTerm2-Color-Schemes.git
cd iTerm2-Color-Schemes
```

2. Create a Python script to convert the color schemes to one JSON file

```python
import json
from pathlib import Path
from typing import Any


def load_json(f: str) -> dict[str, str]:
    with Path(f).open(encoding="utf-8") as fp:
        return json.load(fp)


def save_json(obj: dict[str, Any], f: str) -> None:
    with Path(f).open("w", encoding="utf-8") as fp:
        json.dump(obj, fp, indent=2)


def main() -> None:
    root = Path("./windowsterminal")

    d = []
    for f in root.glob("*.json"):
        d += [load_json(f) | {"name": f.stem}]

    save_json(d, "schemes.json")


if __name__ == "__main__":
    main()
```

3. Copy the converted schemes to the Windows Terminal Settings

> https://github.com/mbadolato/iTerm2-Color-Schemes/tree/master?tab=readme-ov-file#windows-terminal-color-schemes
> Copy the theme content from windowsterminal/ and paste the content to your profiles.json in the corresponding place ("schemes"). Then specify the name of your theme by "colorScheme" in "profiles".
