"""
Post-process xathi sprites toward /tg/station house pixel-art style.

/tg/station style (from moth.dmi / lizard.dmi analysis):
- No cartoon outlines: edges blend naturally
- 12-20 colors per 32x32 sprite with deliberate shading bands
- Hue-shifted shadows (cooler) and highlights (warmer)
- Band compression instead of smooth AI gradients

Approach: median-cut quantization on opaque pixels only, then hue-shift
the palette extremes for the /tg/station feel.

Usage:
    python tools/fix_xathi_sprites.py icons/obj/food/xathi.dmi -o output.dmi
"""

import sys
import os
import warnings
import numpy as np
from PIL import Image

warnings.filterwarnings('ignore', category=RuntimeWarning, message='.*overflow.*')

sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'dmi'))
from dmi import Dmi


def luminance(r, g, b):
    return 0.299 * r + 0.587 * g + 0.114 * b


def rgb_to_hsv(r, g, b):
    r, g, b = r / 255.0, g / 255.0, b / 255.0
    mx = max(r, g, b)
    mn = min(r, g, b)
    diff = mx - mn
    if diff == 0:
        h = 0.0
    elif mx == r:
        h = (60.0 * ((g - b) / diff) + 360.0) % 360.0
    elif mx == g:
        h = (60.0 * ((b - r) / diff) + 120.0) % 360.0
    else:
        h = (60.0 * ((r - g) / diff) + 240.0) % 360.0
    s = 0.0 if mx == 0 else diff / mx
    v = mx
    return h, s, v


def hsv_to_rgb(h, s, v):
    h = h % 360.0
    c = v * s
    x = c * (1 - abs((h / 60.0) % 2 - 1))
    m = v - c
    if 0 <= h < 60:
        r, g, b = c, x, 0
    elif 60 <= h < 120:
        r, g, b = x, c, 0
    elif 120 <= h < 180:
        r, g, b = 0, c, x
    elif 180 <= h < 240:
        r, g, b = 0, x, c
    elif 240 <= h < 300:
        r, g, b = x, 0, c
    else:
        r, g, b = c, 0, x
    return int(round((r + m) * 255)), int(round((g + m) * 255)), int(round((b + m) * 255))


def hue_shift_color(r, g, b, shift_deg):
    h, s, v = rgb_to_hsv(r, g, b)
    h = (h + shift_deg) % 360.0
    return hsv_to_rgb(h, s, v)


def nearest_color(r, g, b, palette):
    r, g, b = int(r), int(g), int(b)
    return min(palette, key=lambda p: (r - int(p[0]))**2 + (g - int(p[1]))**2 + (b - int(p[2]))**2)


def process_frame(frame, n_colors):
    arr = np.array(frame, dtype=np.uint8)
    if arr.shape[2] < 4:
        arr = np.dstack([arr, np.full(arr.shape[:2], 255, dtype=np.uint8)])

    alpha = arr[:, :, 3]
    opaque = alpha > 128
    if not opaque.any():
        return frame

    h, w = arr.shape[:2]

    # Collect original palette and identify extreme colors to preserve
    orig_pixels = set()
    for y in range(h):
        for x in range(w):
            if opaque[y, x]:
                orig_pixels.add(tuple(int(v) for v in arr[y, x, :3]))
    orig_sorted = sorted(orig_pixels, key=lambda p: luminance(*p))

    # Quantize using median cut
    work_rgb = arr[:, :, :3].copy()
    work_rgb[~opaque] = [255, 0, 255]

    pil_rgb = Image.fromarray(work_rgb, 'RGB')
    quantized_p = pil_rgb.quantize(colors=n_colors, method=Image.Quantize.MEDIANCUT)
    quantized_rgb = np.array(quantized_p.convert('RGB'), dtype=np.uint8)

    for y in range(h):
        for x in range(w):
            if opaque[y, x] and tuple(quantized_rgb[y, x]) == (255, 0, 255):
                quantized_rgb[y, x] = arr[y, x, :3]

    result_arr = np.dstack([quantized_rgb, alpha])
    result_arr[~opaque] = arr[~opaque]

    # Extract quantized palette (normalize to Python int tuples)
    pixels = set()
    for y in range(h):
        for x in range(w):
            if opaque[y, x]:
                pixels.add(tuple(int(v) for v in result_arr[y, x, :3]))
    palette = sorted(pixels, key=lambda p: luminance(*p))
    if len(palette) == 0:
        return frame

    # Preserve original extreme colors (darkest 2, lightest 2) by appending
    # them to the palette. This ensures accent colors (blood-red, bright
    # highlights) aren't lost during median-cut quantization.
    preserved = set()
    if len(orig_sorted) >= 1:
        preserved.add(orig_sorted[0])
    if len(orig_sorted) >= 2:
        preserved.add(orig_sorted[1])
    if len(orig_sorted) >= 2:
        preserved.add(orig_sorted[-2])
    if len(orig_sorted) >= 1:
        preserved.add(orig_sorted[-1])

    palette.extend(preserved)
    palette = list(set(palette))
    palette = sorted(palette, key=lambda p: luminance(*p))

    # Hue shift non-preserved palette entries only
    # (preserved extremes must stay at their original hue to act as
    #  valid nearest-color targets for original extreme pixels)
    non_preserved = [c for c in palette if c not in preserved]
    non_preserved.sort(key=lambda p: luminance(*p))
    # Build index map from value → position
    idx_map = {c: i for i, c in enumerate(palette)}
    if len(non_preserved) >= 2:
        for c, shift in [(non_preserved[0], -10), (non_preserved[1], -5),
                         (non_preserved[-1], 8)]:
            palette[idx_map[c]] = hue_shift_color(*c, shift)
        if len(non_preserved) >= 4:
            palette[idx_map[non_preserved[-2]]] = hue_shift_color(*non_preserved[-2], 4)
    elif len(non_preserved) == 1:
        palette[idx_map[non_preserved[0]]] = hue_shift_color(*non_preserved[0], -5)

    # Remap using ORIGINAL pixel values against combined palette
    # This ensures preserved extreme colors actually get used
    output = arr.copy()
    for y in range(h):
        for x in range(w):
            if opaque[y, x]:
                r, g, b = arr[y, x, :3]
                nr, ng, nb = nearest_color(r, g, b, palette)
                output[y, x, :3] = [nr, ng, nb]

    return Image.fromarray(output, 'RGBA')


def main():
    import argparse
    parser = argparse.ArgumentParser(description='Convert sprites to /tg/station house style')
    parser.add_argument('input', help='Input .dmi file')
    parser.add_argument('-o', '--output', default=None, help='Output .dmi file (default: input_fixed.dmi)')
    parser.add_argument('-n', '--ncolors', type=int, default=16, help='Target color count (default: 16)')
    args = parser.parse_args()

    if args.output is None:
        base, ext = os.path.splitext(args.input)
        args.output = f"{base}_fixed{ext}"

    dmi = Dmi.from_file(args.input)
    print(f"Processing {os.path.basename(args.input)}")
    print(f"  {len(dmi.states)} states, {dmi.width}x{dmi.height}px")

    for state in dmi.states:
        for i, frame in enumerate(state.frames):
            before = len(frame.getcolors())
            state.frames[i] = process_frame(frame, args.ncolors)
            after = len(state.frames[i].getcolors())
            print(f"  {state.name}[{i}]: {before} colors -> {after} colors")

    dmi.to_file(args.output)
    print(f"\nSaved to {args.output}")
    print("Note: This is a mechanical first pass. Hand-touch for pixel-perfect quality.")


if __name__ == '__main__':
    main()
