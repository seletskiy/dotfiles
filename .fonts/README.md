# Building fonts

```bash
git clone https://github.com/be5invis/Iosevka /tmp/iosevka
cd /tmp/iosevka
```

parameters.toml:

```toml
powerlineScaleX = 1.2 # Horizontal scale
powerlineShiftY = 20 # Vertical shift
powerlineShiftX = -30 # Horizontal shift
```

```bash
make custom-config design='cv13 cv19 cv36 cv38 cv17 cv31'
make custom -j 4
cp /tmp/iosevka/dist/iosevka-custom/ttf/iosevka-custom-*.ttf ~/.fonts
fc-cache -vf
```
