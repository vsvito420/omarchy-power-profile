<div align="center">

<img src="icon.svg" width="96" alt="Power Profile Icon">

# omarchy-power-profile

**Ein Energieprofil-Tacho für die Omarchy-Leiste: drüberscrollen, um zwischen Energiesparen, Ausgewogen und Leistung zu wechseln.**
Für [Omarchy](https://omarchy.org) / Hyprland.

[![Omarchy](https://img.shields.io/badge/Omarchy-Shell_Plugin-1793d1?style=for-the-badge&logo=archlinux&logoColor=white)](https://omarchy.org)
[![QML](https://img.shields.io/badge/QML-Quickshell-41cd52?style=for-the-badge&logo=qt&logoColor=white)](#so-funktionierts)
[![Lizenz: MIT](https://img.shields.io/badge/Lizenz-MIT-green?style=for-the-badge)](LICENSE)
[![English](https://img.shields.io/badge/read_me-English-black?style=for-the-badge)](README.md)

![Der Tacho in der Omarchy-Leiste: Energiesparen, Ausgewogen, Leistung](screenshots/closeup.png)

</div>

---

## Was es zeigt

Ein kleiner Tacho mit drei Segmenten. Die hellen Segmente und die Nadel zeigen das aktive Profil:

| Tacho | Profil |
|---|---|
| ◔ 1 von 3 hell | **Energiesparen** |
| ◑ 2 von 3 hell | **Ausgewogen** |
| ● 3 von 3 hell, in Akzentfarbe | **Leistung** |

## Bedienung

| | |
|---|---|
| 🖱️ **Hoch / runter scrollen** | Mehr / weniger Leistung. Bleibt an beiden Enden stehen, Touchpads schalten pro voller Raste einmal |
| 👆 **Linksklick** | Reihum zum nächsten Profil |
| 🔋 **Mittel- / Rechtsklick** | Öffnet das Omarchy-Energiemenü |

## Installieren

```bash
omarchy plugin add https://github.com/vsvito420/omarchy-power-profile.git --enable
```

Legt das Plugin nach `~/.config/omarchy/plugins/vsvito.power-profile` und setzt das Widget in die Leiste.
Verschieben, zum Beispiel direkt hinter den Akku:

```bash
omarchy bar move vsvito.power-profile --after omarchy.power
```

Aktualisieren mit `omarchy plugin update vsvito.power-profile`, entfernen mit `omarchy plugin remove vsvito.power-profile`.

## So funktioniert's

- **Lesen:** Das aktive Profil kommt live von `power-profiles-daemon` über den `PowerProfiles`-Dienst von Quickshell,
  der Tacho folgt also auch Änderungen von anderswo (Energiemenü, `powerprofilesctl`).
- **Wechseln:** läuft über `omarchy-powerprofiles-set`, genau wie im Omarchy-Energiemenü. Omarchy merkt sich die Wahl
  getrennt für Netzteil und Akku und stellt sie beim Ein- und Ausstecken wieder her.
- **Zeichnen:** Der Tacho wird mit einem `Canvas` in den Farben der Leiste gemalt und passt so zu jedem Omarchy-Theme.

## Voraussetzungen

- Omarchy mit der Quickshell-basierten Shell (Leisten-Widgets über `~/.config/omarchy/plugins/`)
- `power-profiles-daemon` (bei Omarchy dabei)

## Lizenz

[MIT](LICENSE) © 2026 vsvito420
