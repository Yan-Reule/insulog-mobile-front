#!/usr/bin/python3
"""Gera os ícones a partir do SVG: /usr/bin/python3 tool/generate_app_icons.py.

Requer PyGObject, librsvg e Pillow (pacotes do sistema).
"""
import json
from pathlib import Path

import gi
from PIL import Image

gi.require_version('Rsvg', '2.0')
from gi.repository import Rsvg

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'assets/images/logo_insulog.svg'
RES = ROOT / 'android/app/src/main/res'
svg_source = SOURCE.read_text()


def render(path, size, logo_fraction, opaque=True):
    height = size * logo_fraction
    width = height * 208 / 285
    background = '<rect width="100%" height="100%" fill="white"/>' if opaque else ''
    nested = svg_source.replace(
        '<svg width="208" height="285"',
        f'<svg x="{(size - width) / 2}" y="{(size - height) / 2}" width="{width}" height="{height}"',
        1,
    )
    document = f'<svg xmlns="http://www.w3.org/2000/svg" width="{size}" height="{size}">{background}{nested}</svg>'
    handle = Rsvg.Handle.new_from_data(document.encode())
    path.parent.mkdir(parents=True, exist_ok=True)
    handle.get_pixbuf().savev(str(path), 'png', [], [])
    if opaque:
        with Image.open(path) as image:
            image.convert('RGB').save(path)



for density, scale in {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}.items():
    folder = RES / f'mipmap-{density}'
    render(folder / 'ic_launcher.png', round(48 * scale), 0.72)
    # A camada adaptável tem 108dp; a logo ocupa 60dp no centro.
    render(folder / 'ic_launcher_foreground.png', round(108 * scale), 60 / 108, opaque=False)

adaptive = RES / 'mipmap-anydpi-v26/ic_launcher.xml'
adaptive.parent.mkdir(parents=True, exist_ok=True)
adaptive.write_text('''<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@android:color/white" />
    <foreground android:drawable="@mipmap/ic_launcher_foreground" />
</adaptive-icon>
''')

icons = ROOT / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
contents = json.loads((icons / 'Contents.json').read_text())
for entry in contents['images']:
    size = round(float(entry['size'].split('x')[0]) * float(entry['scale'].removesuffix('x')))
    render(icons / entry['filename'], size, 0.72)

print('Ícones Android e iOS gerados a partir de', SOURCE.relative_to(ROOT))
