import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import CyberMedia 1.0

Window {
    id: window
    width: 800; height: 600
    visible: true
    color: "#02040a" // Ультра-черный фон
    title: "NEON SIGNAL ANALYZER"

    AudioLevel { id: audio }

    // --- 1. КИБЕР-СЕТКА (Background Grid) ---
    Item {
        anchors.fill: parent
        opacity: 0.15
        
        Repeater {
            model: 20
            Rectangle {
                width: parent.width; height: 1; color: "#38bdf8"
                y: index * (window.height / 20)
            }
        }
        Repeater {
            model: 30
            Rectangle {
                width: 1; height: parent.height; color: "#38bdf8"
                x: index * (window.width / 30)
            }
        }
    }

    // --- 2. ЦЕНТРАЛЬНЫЙ СКАНЕР (Main Visualizer) ---
    Item {
        anchors.centerIn: parent
        width: 400; height: 400

        // Внешнее "дышащее" кольцо
        Rectangle {
            anchors.centerIn: parent
            width: 300 + audio.level * 250
            height: width; radius: width/2
            color: "transparent"; border.color: "#f43f5e"
            border.width: 2; opacity: 0.2 + audio.level
            
            Behavior on width { SpringAnimation { spring: 2; damping: 0.3 } }
        }

        // Эквалайзер "Звезда"
        Repeater {
            model: 80
            delegate: Rectangle {
                id: bar
                readonly property real angle: index * (360 / 80) * (Math.PI / 180)
                width: 2; height: 30 + (audio.level * 200 * (index % 2 ? 1 : 0.6))
                radius: 1
                color: index % 2 ? "#38bdf8" : "#f43f5e" // Чередование цветов
                
                x: Math.cos(angle) * 120 + 200
                y: Math.sin(angle) * 120 + 200
                rotation: index * (360 / 80) + 90
                
                // Эффект свечения через прозрачность
                opacity: 0.4 + audio.level * 0.6

                Behavior on height { 
                    SpringAnimation { spring: 3; damping: 0.2; epsilon: 0.1 } 
                }
            }
        }

        // Центральное ядро
        Rectangle {
            anchors.centerIn: parent
            width: 80; height: 80; radius: 40
            color: "#050505"; border.color: "#38bdf8"; border.width: 2
            
            Text {
                anchors.centerIn: parent
                text: Math.floor(audio.level * 100)
                color: "#38bdf8"; font.pixelSize: 28; font.family: "Monospace"
                font.bold: true
            }
            
            // Внутренний импульс
            Rectangle {
                anchors.fill: parent; radius: 40
                color: "#38bdf8"; opacity: audio.level * 0.3
                scale: 1 + audio.level
            }
        }
    }

    // --- 3. ИНФОРМАЦИОННЫЕ ПАНЕЛИ (Hud Elements) ---
    RowLayout {
        anchors.bottom: parent.bottom; anchors.left: parent.left
        anchors.margins: 30; spacing: 20

        Column {
            Text { text: "SIGNAL STRENGTH"; color: "#38bdf8"; font.pixelSize: 10; font.letterSpacing: 2 }
            Rectangle {
                width: 150; height: 4; color: "#1e293b"; radius: 2
                Rectangle {
                    width: parent.width * audio.level; height: 4
                    color: "#38bdf8"; radius: 2
                    Behavior on width { NumberAnimation { duration: 100 } }
                }
            }
        }
    }

    Text {
        anchors.top: parent.top; anchors.right: parent.right
        anchors.margins: 30
        text: "RHI: VULKAN/OPENGL ACTIVE\nSAMPLING: 44100HZ"
        color: "#f43f5e"; font.pixelSize: 10; horizontalAlignment: Text.AlignRight
        opacity: 0.6
    }
}
