/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ToolBar {
    id: root

    property alias progressBar: progressBar
    property alias footerRow: footerRow
    property alias timeInfo: timeInfo
    property alias playPauseButton: playPauseButton
    property alias volume: volume

    y: mpv.height
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: isFullScreen() ? mpv.bottom : window.bottom
    padding: 5
    position: ToolBar.Footer
    hoverEnabled: true
    visible: !window.isFullScreen() || mpv.my > window.height - footer.height

    RowLayout {
        id: footerRow
        anchors.fill: parent

        ToolButton {
            icon.name: "application-menu"
            visible: !menuBar.visible
            onClicked: {
                if (mpvContextMenu.visible) {
                    return
                }

                mpvContextMenu.visible = !mpvContextMenu.visible
                const menuHeight = mpvContextMenu.count * mpvContextMenu.itemAt(0).height
                mpvContextMenu.popup(footer, 0, -menuHeight)
            }
        }

        ToolButton {
            id: playPauseButton
            action: actions.playPauseAction
            text: ""
            icon.name: "media-playback-start"

            ToolTip {
                id: playPauseButtonToolTip
                text: mpv.pause ? qsTr("Start Playback") : qsTr("Pause Playback")
            }
        }

        ToolButton {
            id: playPreviousFile
            action: actions.playPreviousAction
            text: ""

            ToolTip {
                text: qsTr("Play Previous File")
            }
        }

        ToolButton {
            id: playNextFile
            action: actions.playNextAction
            text: ""

            ToolTip {
                text: qsTr("Play Next File")
            }
        }

        HProgressBar {
            id: progressBar
            Layout.fillWidth: true
        }

        Label {
            id: timeInfo

            text: timeInfoTextMetrics.text
            font.pointSize: timeInfoTextMetrics.font.pointSize
            horizontalAlignment: Qt.AlignHCenter
            Layout.preferredWidth: timeInfoTextMetrics.width + 50

            TextMetrics {
                id: timeInfoTextMetrics

                text: app.formatTime(mpv.position) + " / " + app.formatTime(mpv.duration)
                font.pointSize: 14
            }

            ToolTip {
                text: qsTr("Remaining: ") + app.formatTime(mpv.remaining)
                visible: timeInfoMouseArea.containsMouse
                timeout: -1
            }


            MouseArea {
                id: timeInfoMouseArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

        ToolButton {
            id: mute
            action: actions.muteAction
            text: ""

            ToolTip {
                text: actions.muteAction.text
            }
        }

        VolumeSlider { id: volume }
    }
}
