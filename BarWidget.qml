import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

// RunCat — a cat that runs faster when CPU is busy.
// 5 frames cycled at a speed proportional to CPU load.
// Idle CPU = slow stroll, high CPU = sprint.
BarWidget {
  id: root
  moduleName: "io.github.joejoeflyn.runcat"

  property int cpuPercent: 0
  property int frameIndex: 0
  readonly property int frameCount: 5
  readonly property int frameInterval: Math.max(80, 600 - cpuPercent * 5)

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function parseCpu(text) {
    var lines = String(text || "").split("\n")
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i].trim()
      if (line.indexOf("cpu") === 0) {
        var parts = line.split(/\s+/)
        var pct = parseInt(parts[1], 10)
        return isFinite(pct) ? Math.max(0, Math.min(100, pct)) : 0
      }
    }
    return 0
  }

  function refresh() {
    if (!statsProc.running) statsProc.running = true
  }

  IpcHandler {
    target: "io.github.joejoeflyn.runcat"

    function refresh(): void {
      root.broadcast("refresh")
    }
  }

  Process {
    id: statsProc
    command: ["omarchy-system-stats"]
    running: false
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.cpuPercent = root.parseCpu(text)
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  Timer {
    id: frameTimer
    interval: root.frameInterval
    repeat: true
    running: true
    onTriggered: root.frameIndex = (root.frameIndex + 1) % root.frameCount
    onIntervalChanged: if (running) restart()
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    slotSize: Style.bar.iconSlot
    tooltipText: "CPU " + root.cpuPercent + "%"

    iconComponent: Component {
      Item {
        anchors.centerIn: parent
        width: Style.bar.iconCanvas
        height: Style.bar.iconCanvas

        Image {
          anchors.centerIn: parent
          width: parent.width
          height: parent.height
          source: Qt.resolvedUrl("assets/cat_" + root.frameIndex + ".png")
          fillMode: Image.PreserveAspectFit
          smooth: false
        }
      }
    }

    onPressed: function() {
      if (root.bar) root.bar.run("omarchy-launch-floating-terminal-with-presentation btop")
    }
  }
}
