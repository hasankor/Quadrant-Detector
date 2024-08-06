import QtQuick 2.12
import QtQuick.Controls 2.12
import "../qml/common/custombutton"
import "../qml/common/customcombobox"
import "coordinatesystem"


Rectangle {

    property int screenWidth                                    : controller.width
    property int screenHeight                                   : controller.height
    property bool connectionStatus                              : controller.connectionStatus

    id                                                          : rootRectId
    visible                                                     : true
    anchors.centerIn                                            : parent
    width                                                       : screenWidth
    height                                                      : screenHeight
    color                                                       : "#424769"

    Component.onCompleted                                       : controller.setSelectedPortName(availablePortsComboboxId.currentText)

    // to check available serial ports
    Timer{
        running                                                 : true
        repeat                                                  : true
        interval                                                : 20
        onTriggered                                             : {availablePortsComboboxId.model = controller.availablePorts()}
    }

    CoordinateSystem{
        anchors.top                                             : parent.top
        anchors.topMargin                                       : (parent.width / 95) * 3
        anchors.left                                            : parent.left
        anchors.leftMargin                                      : 75
        width                                                   : (parent.width / 95) * 80
        height                                                  : width
        color                                                   : "#7077A1"
    }



    Rectangle{
        anchors.bottom                                          : parent.bottom
        width                                                   : parent.width
        height                                                  : (parent.height / 85) * 8
        color                                                   : "#2D3250"

        Grid{
            anchors.left                                        : parent.left
            anchors.leftMargin                                  : (parent.width / 85) * 7
            anchors.verticalCenter                              : parent.verticalCenter
            columns                                             : 2
            columnSpacing                                       : 30
            rowSpacing                                          : 20
            visible                                             : connectionStatus
            Label {
                text                                            : "X Point : "
                color                                           : "#F8FAE5"
                font.pixelSize                                  : 15
                font.bold                                       : true
            }
            Label {
                text                                            : (controller.xAxisValue).toFixed(2)
                color                                           : "#F8FAE5"
                font.pixelSize                                  : 15
            }
            Label {
                text                                            : "Y Point : "
                color                                           : "#F8FAE5"
                font.pixelSize                                  : 15
                font.bold                                       : true
            }
            Label {
                text                                            : (controller.yAxisValue).toFixed(2)
                color                                           : "#F8FAE5"
                font.pixelSize                                  : 15
            }
        }


        Row{
            id                                                  : portsRowId
            anchors.right                                       : parent.right
            anchors.rightMargin                                 : parent.width / 80
            anchors.verticalCenter                              : parent.verticalCenter
            spacing                                             : 5
            Label {
                anchors.verticalCenter                          : parent.verticalCenter
                text                                            : "Port : "
                color                                           : "#F8FAE5"
                font.pixelSize                                  : 15
                font.bold                                       : true
            }
            CommonComboBox{
                id                                              : availablePortsComboboxId
                width                                           : 130
                height                                          : 40
                model                                           : controller.availablePorts()
                onCurrentTextChanged                            : controller.setSelectedPortName(currentText)
            }
            CustomButton{
                property bool ejectStatus                       : true

                width                                           : 80
                height                                          : parent.height
                color                                           : isHovered ? "#424769" : "#7077A1"
                enabled                                         : availablePortsComboboxId.count !== 0
                radius                                          : 20
                txt.text                                        : {
                    if(!ejectStatus)
                        return "Eject"
                    else
                        return "Take"
                }
                onClicked                                       : {
                    ejectStatus = !ejectStatus
                    controller.openCloseSerialPort(ejectStatus)
                }
            }
        }
    }
}

