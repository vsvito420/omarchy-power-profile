# Energieprofil-Tacho für die Bar

<img src="https://raw.githubusercontent.com/vsvito420/omarchy-power-profile/main/icon.svg" width="72" alt="Icon des Energieprofil-Tachos">

Ein kleines Widget für die Omarchy-Bar: ein Tacho, der das aktive Energieprofil zeigt.
Drüberscrollen schaltet zwischen Energiesparen, Ausgewogen und Leistung.

![Der Tacho in allen drei Stufen](https://raw.githubusercontent.com/vsvito420/omarchy-power-profile/main/screenshots/closeup.png)

## Was es zeigt

- **Tacho mit drei Segmenten** – die hellen Segmente und die Nadel zeigen das Profil
  - 1 von 3 hell: **Energiesparen**
  - 2 von 3 hell: **Ausgewogen**
  - 3 von 3 hell, in Akzentfarbe: **Leistung**
- **Tooltip** – Name des aktiven Profils

## Bedienung

- **Hoch scrollen** – mehr Leistung, **runter** – weniger
  - bleibt an beiden Enden stehen
  - Touchpads schalten erst nach einer vollen Raste, damit nichts flattert
- **Linksklick** – reihum zum nächsten Profil
- **Mittel- oder Rechtsklick** – öffnet das Omarchy-Energiemenü

## Installieren

```bash
omarchy plugin add https://github.com/vsvito420/omarchy-power-profile.git --enable
```

Legt das Plugin nach `~/.config/omarchy/plugins/vsvito.power-profile`. Direkt hinter den Akku schieben:

```bash
omarchy bar move vsvito.power-profile --after omarchy.power
```

<div class="callout tip" markdown="1">
Nach Änderungen am QML-Code reicht das automatische Neuladen nicht immer – dann `omarchy restart shell`.
</div>

## So funktioniert's

- **Code:** [`PowerProfile.qml`](https://github.com/vsvito420/omarchy-power-profile/blob/main/PowerProfile.qml) – reines QML
- **Lesen:** das aktive Profil kommt live von `power-profiles-daemon` über den `PowerProfiles`-Dienst von Quickshell
  - folgt also auch Änderungen aus dem Energiemenü oder per `powerprofilesctl`
- **Wechseln:** über `omarchy-powerprofiles-set`, wie das Omarchy-Energiemenü
  - die Wahl wird getrennt für Netzteil und Akku gemerkt (`~/.local/state/omarchy/powerprofiles/`)
- **Zeichnen:** der Tacho ist ein `Canvas` in den Farben der Bar, passt also zu jedem Theme
  - 240°-Bogen in drei Segmenten, die Nadel zeigt genau auf 1/3, 2/3 oder 3/3
  - bei Bargröße waren die Tacho-Glyphen der Nerd Font kaum zu unterscheiden – deshalb selbst gezeichnet

## Siehe auch

- [[Omarchy]]
- [[Sonnenkurve für die Bar]], [[AirPods unter Omarchy]]
