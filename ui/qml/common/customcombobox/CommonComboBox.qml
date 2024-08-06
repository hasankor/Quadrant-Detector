import QtQuick 2.12
import QtQuick.Controls 2.12

ComboBox{
    id                                              : comboboxId
    currentIndex                                    : 0

    //the background of the combobox
    background                                      : Rectangle {
        color                                       : "#7077A1"
    }

    delegate                                        : ItemDelegate {
        id                                          : itemDlgt
        width                                       : parent.width

        contentItem                                 : Text {
            id                                      : textItem
            text                                    : modelData
            color                                   : "#F8FAE5"
            elide                                   : Text.ElideRight
            verticalAlignment                       : Text.AlignVCenter
            horizontalAlignment                     : Text.AlignLeft
            leftPadding                             : 20
        }

        background                                  : Rectangle {
            color                                   : itemDlgt.hovered ? "#424769" : "#7077A1"
            anchors.left                            : itemDlgt.left
            anchors.leftMargin                      : 0
            width                                   : itemDlgt.width - 2
        }
    }

    //the arrow on the right in the combobox
    indicator                                       : Canvas {
        id                                          : canvas
        x                                           : comboboxId.width - width - comboboxId.rightPadding
        y                                           : comboboxId.topPadding + (comboboxId.availableHeight - height) / 2
        width                                       : 12
        height                                      : 8
        contextType                                 : "2d"

        Connections {
            target                                  : comboboxId
            function onPressedChanged() { canvas.requestPaint()}
        }

        onPaint                                     : {
            context.reset()
            context.moveTo(0, 0)
            context.lineTo(width, 0)
            context.lineTo(width / 2, height)
            context.closePath()
            context.fillStyle = "#F8FAE5"
            context.fill()
        }
    }

    //the text in the combobox
    contentItem                                     : Text {
        leftPadding                                 : 20
        rightPadding                                : comboboxId.indicator.width + comboboxId.spacing
        text                                        : comboboxId.displayText
        font.bold                                   : true
        color                                       : "#F8FAE5"
        verticalAlignment                           : Text.AlignVCenter
        horizontalAlignment                         : Text.AlignHCenter
        elide                                       : Text.ElideRight
    }
    popup                                           : Popup {
        y                                           : comboboxId.height - 1
        width                                       : comboboxId.width
        padding                                     : 1
        implicitHeight                              : contentItem.implicitHeight

        contentItem                                 : ListView {
            clip                                    : true
            model                                   : comboboxId.popup.visible ? comboboxId.delegateModel : null
            implicitHeight                          : contentHeight
            currentIndex                            : comboboxId.highlightedIndex
            ScrollBar.vertical                      : ScrollBar {
            active                                  : true
            }
        }

        background                                  : Rectangle {
            radius                                  : 2
            color                                   : "#F8FAE5"
            border.color                            : "#F8FAE5"
        }
    }
}
