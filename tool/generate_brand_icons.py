"""Generate StreetBite launcher icons and logo from the in-app brand mark.

The mark is Material Icons `ramen_dining_rounded` (U+F00DB), the same glyph the
onboarding and authentication screens show, on StreetBite orange (#E86B36).
Usage: python tool/generate_brand_icons.py <path to MaterialIcons-Regular.otf>
"""

import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
ORANGE = (232, 107, 54, 255)
CREAM = (255, 250, 245, 255)
GLYPH = chr(0xF00DB)
DENSITIES = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
# Adaptive icon layers are 108dp; the glyph stays inside the 66dp safe zone.
ADAPTIVE = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}


def mark(size, font_path, background=ORANGE, foreground=CREAM, rounded=True, glyph_ratio=0.62):
    scale = 4  # supersample for smooth edges
    big = size * scale
    image = Image.new("RGBA", (big, big), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    if background is None:
        pass
    elif rounded:
        draw.ellipse((0, 0, big - 1, big - 1), fill=background)
    else:
        draw.rectangle((0, 0, big, big), fill=background)
    font = ImageFont.truetype(font_path, int(big * glyph_ratio))
    left, top, right, bottom = draw.textbbox((0, 0), GLYPH, font=font)
    x = (big - (right - left)) / 2 - left
    y = (big - (bottom - top)) / 2 - top
    draw.text((x, y), GLYPH, font=font, fill=foreground)
    return image.resize((size, size), Image.LANCZOS)


def main(font_path):
    res = ROOT / "android" / "app" / "src" / "main" / "res"
    for density, size in DENSITIES.items():
        mark(size, font_path).save(res / f"mipmap-{density}" / "ic_launcher.png")
    for density, size in ADAPTIVE.items():
        mark(size, font_path, background=None, glyph_ratio=0.5).save(
            res / f"mipmap-{density}" / "ic_launcher_foreground.png")
    anydpi = res / "mipmap-anydpi-v26"
    anydpi.mkdir(exist_ok=True)
    (anydpi / "ic_launcher.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '    <background android:drawable="@color/ic_launcher_background"/>\n'
        '    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>\n'
        '    <monochrome android:drawable="@mipmap/ic_launcher_foreground"/>\n'
        '</adaptive-icon>\n')
    (res / "values" / "ic_launcher_background.xml").write_text(
        '<?xml version="1.0" encoding="utf-8"?>\n<resources>\n'
        '    <color name="ic_launcher_background">#E86B36</color>\n</resources>\n')
    branding = ROOT / "assets" / "branding"
    branding.mkdir(parents=True, exist_ok=True)
    mark(1024, font_path).save(branding / "streetbite_logo.png")
    mark(1024, font_path, rounded=False).save(branding / "streetbite_logo_square.png")
    print("generated launcher icons and", branding)


if __name__ == "__main__":
    main(sys.argv[1])
