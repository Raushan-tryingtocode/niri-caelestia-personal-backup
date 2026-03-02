pragma ComponentBehavior: Bound

import ".."
import "../components"
import qs.components
import qs.components.controls
import qs.components.effects
import qs.components.containers
import qs.services
import qs.config
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property Session session

    property bool enabled: Config.osd.enabled ?? true
    property int hideDelay: Config.osd.hideDelay ?? 1500
    property bool enableBrightness: Config.osd.enableBrightness ?? true
    property bool enableMicrophone: Config.osd.enableMicrophone ?? true

    anchors.fill: parent

    function saveConfig() {
        Config.osd.enabled = root.enabled;
        Config.osd.hideDelay = root.hideDelay;
        Config.osd.enableBrightness = root.enableBrightness;
        Config.osd.enableMicrophone = root.enableMicrophone;
        Config.save();
    }

    ClippingRectangle {
        id: osdClippingRect
        anchors.fill: parent
        anchors.margins: Appearance.padding.md
        anchors.leftMargin: 0
        anchors.rightMargin: Appearance.padding.md

        radius: osdBorder.innerRadius
        color: "transparent"

        Loader {
            id: osdLoader
            anchors.fill: parent
            anchors.margins: Appearance.padding.xl + Appearance.padding.md
            anchors.leftMargin: Appearance.padding.xl
            anchors.rightMargin: Appearance.padding.xl

            sourceComponent: osdContentComponent
        }
    }

    InnerBorder {
        id: osdBorder
        leftThickness: 0
        rightThickness: Appearance.padding.md
    }

    Component {
        id: osdContentComponent

        StyledFlickable {
            id: osdFlickable
            flickableDirection: Flickable.VerticalFlick
            contentHeight: osdLayout.height

            StyledScrollBar.vertical: StyledScrollBar {
                flickable: osdFlickable
            }

            ColumnLayout {
                id: osdLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                spacing: Appearance.spacing.lg

                RowLayout {
                    spacing: Appearance.spacing.md

                    StyledText {
                        text: qsTr("On-Screen Display")
                        font.pointSize: Appearance.font.size.titleMedium
                        font.weight: 500
                    }
                }

                // General Section
                SectionContainer {
                    alignTop: true

                    StyledText {
                        text: qsTr("General")
                        font.pointSize: Appearance.font.size.bodyMedium
                    }

                    SwitchRow {
                        label: qsTr("Enabled")
                        checked: root.enabled
                        onToggled: checked => {
                            root.enabled = checked;
                            root.saveConfig();
                        }
                    }

                    SectionContainer {
                        contentSpacing: Appearance.spacing.lg

                        SliderInput {
                            Layout.fillWidth: true

                            label: qsTr("Hide delay")
                            value: root.hideDelay
                            from: 500
                            to: 10000
                            stepSize: 250
                            suffix: "ms"
                            validator: IntValidator { bottom: 500; top: 10000 }
                            formatValueFunction: val => Math.round(val).toString()
                            parseValueFunction: text => parseInt(text)

                            onValueModified: newValue => {
                                root.hideDelay = Math.round(newValue);
                                root.saveConfig();
                            }
                        }
                    }
                }

                // Indicators Section
                SectionContainer {
                    alignTop: true

                    StyledText {
                        text: qsTr("Indicators")
                        font.pointSize: Appearance.font.size.bodyMedium
                    }

                    SwitchRow {
                        label: qsTr("Brightness")
                        checked: root.enableBrightness
                        onToggled: checked => {
                            root.enableBrightness = checked;
                            root.saveConfig();
                        }
                    }

                    SwitchRow {
                        label: qsTr("Microphone")
                        checked: root.enableMicrophone
                        onToggled: checked => {
                            root.enableMicrophone = checked;
                            root.saveConfig();
                        }
                    }
                }
            }
        }
    }
}
