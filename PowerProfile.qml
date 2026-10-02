import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import qs.Ui

// Power profile switcher: scroll up for more power, down for less,
// left click cycles, middle click opens the Omarchy power panel.
BarWidget {
  id: root
  moduleName: "vsvito.power-profile"

  readonly property var names: PowerProfiles.hasPerformanceProfile
    ? ["power-saver", "balanced", "performance"]
    : ["power-saver", "balanced"]
  readonly property var labels: ({ "power-saver": "Power saver", "balanced": "Balanced", "performance": "Performance" })

  readonly property string active: {
    if (PowerProfiles.profile === PowerProfile.PowerSaver) return "power-saver"
    if (PowerProfiles.profile === PowerProfile.Performance) return "performance"
    return "balanced"
  }
  // Optimistic target while a switch is in flight, so fast scrolling steps
  // from the last requested profile instead of the not-yet-updated one.
  property string pending: ""
  readonly property string shown: pending !== "" ? pending : active

  // Carry sub-notch touchpad deltas between wheel events.
  property real wheelAccumulator: 0

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function step(delta) {
    var i = names.indexOf(shown)
    if (i < 0) i = 1
    var next = Math.max(0, Math.min(names.length - 1, i + delta))
    setProfile(names[next])
  }

  function cycle() {
    var i = names.indexOf(shown)
    setProfile(names[(i + 1) % names.length])
  }

  function setProfile(name) {
    if (name === shown) return
    pending = name
    if (!setProc.running) runPending()
  }

  // Goes through omarchy-powerprofiles-set so the choice is remembered for
  // the current power source (AC or battery), like the power panel does.
  function runPending() {
    setProc.command = ["omarchy-powerprofiles-set", UPower.onBattery ? "battery" : "ac", pending]
    setProc.target = pending
    setProc.running = true
  }

  Process {
    id: setProc
    property string target: ""
    onExited: {
      if (root.pending !== "" && root.pending !== target) root.runPending()
      else clearPending.restart()
    }
  }

  // Let PowerProfiles catch up before dropping the optimistic value.
  Timer {
    id: clearPending
    interval: 400
    onTriggered: root.pending = ""
  }

  // 1, 2 or 3 of 3 segments lit
  readonly property int level: Math.max(1, names.indexOf(shown) + 1)

  // Hand-drawn gauge: a 240° arc in three segments, the lit ones up to the
  // current level, with the needle pointing at the end of the last lit one.
  Component {
    id: gaugeIcon

    Canvas {
      id: canvas
      readonly property int level: root.level
      readonly property color color: button.active && button.useActiveColor ? button.activeColor : button.foreground
      onLevelChanged: requestPaint()
      onColorChanged: requestPaint()
      onWidthChanged: requestPaint()
      onHeightChanged: requestPaint()

      onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        var size = Math.min(width, height)
        var line = Math.max(1.5, size * 0.14)
        var cx = width / 2
        var cy = height / 2 + size * 0.1
        var r = size / 2 - line / 2
        var start = 150 * Math.PI / 180
        var sweep = 240 * Math.PI / 180
        var gap = 0.22
        ctx.lineCap = "butt"
        ctx.lineWidth = line

        for (var i = 0; i < 3; i++) {
          ctx.beginPath()
          ctx.strokeStyle = i < level ? color : Qt.alpha(color, 0.25)
          ctx.arc(cx, cy, r, start + i * sweep / 3 + (i > 0 ? gap / 2 : 0),
                  start + (i + 1) * sweep / 3 - (i < 2 ? gap / 2 : 0), false)
          ctx.stroke()
        }

        var a = start + level * sweep / 3
        var needle = r - line * 1.2
        ctx.beginPath()
        ctx.strokeStyle = color
        ctx.lineCap = "round"
        ctx.lineWidth = Math.max(1.5, size * 0.12)
        ctx.moveTo(cx, cy)
        ctx.lineTo(cx + Math.cos(a) * needle, cy + Math.sin(a) * needle)
        ctx.stroke()

        ctx.beginPath()
        ctx.fillStyle = color
        ctx.arc(cx, cy, Math.max(1.5, size * 0.11), 0, 2 * Math.PI)
        ctx.fill()
      }
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    iconComponent: gaugeIcon
    active: root.shown === "performance"
    tooltipText: (root.labels[root.shown] || root.shown) + " · scroll to change"
    onPressed: function(b) {
      if (b === Qt.MiddleButton || b === Qt.RightButton) root.bar.run("omarchy-shell shell toggle omarchy.power")
      else root.cycle()
    }
    onWheelMoved: function(delta) {
      root.wheelAccumulator += delta
      if (Math.abs(root.wheelAccumulator) < 120) return
      root.step(root.wheelAccumulator > 0 ? 1 : -1)
      root.wheelAccumulator = 0
    }
  }
}
