import QtQuick 2.0
import "../common/customline"

Rectangle {

    property var pointX                                     : controller.xAxisValue
    property var pointY                                     : controller.yAxisValue
    property real axisLength                                : width / 2
    property var centerPointX                               : width / 2
    property var centerPointY                               : height / 2
    property var intexStepSize                              : 0.1
    property real divisionValue                             : 10
    property color axisLineColor                            : "#0F1035"
    property var stepSizeOfCoordinatSystem                  : (width / 2) / divisionValue

    color                                                   : "transparent"

//    onPointXChanged: {
//        console.log("QML X: ", pointX.toFixed(2))
//    }
//    onPointYChanged: {
//        console.log("QML Y: ", pointY.toFixed(2))
//    }

    // y axis
    CustomLine{
        startX                                              : 0
        endX                                                : parent.width
        startY                                              : parent.height / 2
        endY                                                : parent.height / 2
        opacity                                             : 0.75
    }

    // x axis
    CustomLine{
        startX                                              : 0
        endX                                                : parent.width
        startY                                              : parent.height / 2
        endY                                                : parent.height / 2
        rotation                                            : 90
        opacity                                             : 0.75
    }

    // Label for positive x-axis
    Repeater {
        model                                               : Math.floor(axisLength / stepSizeOfCoordinatSystem) + 1
        Rectangle {
            width                                           : 15
            height                                          : 1
            anchors.verticalCenter                          : parent.verticalCenter
            x                                               : centerPointX + (index * stepSizeOfCoordinatSystem) - (width / 2)
            y                                               : centerPointY
            rotation                                        : 90
            color                                           : axisLineColor
            opacity                                         : 0.5

            Text {
                anchors.right                               : parent.left
                anchors.rightMargin                         : 3
                anchors.verticalCenter                      : parent.verticalCenter
                text                                        : (index * intexStepSize) === 0 ? "" : (index * intexStepSize).toPrecision(1)
                font.pixelSize                              : 12
                color                                       : axisLineColor
                rotation                                    : -90
            }
        }
    }

    // Label for negative x-axis
    Repeater {
        model                                               : Math.floor(axisLength / stepSizeOfCoordinatSystem) + 1
        Rectangle {
            width                                           : 15
            height                                          : 1
            anchors.verticalCenter                          : parent.verticalCenter
            x                                               : centerPointX - (index * stepSizeOfCoordinatSystem) - (width / 2)
            y                                               : centerPointY
            rotation                                        : 90
            color                                           : axisLineColor
            opacity                                         : 0.5

            Text {
                anchors.right                               : parent.left
                anchors.rightMargin                         : 3
                anchors.verticalCenter                      : parent.verticalCenter
                text                                        : -(index * intexStepSize) === 0 ? "" : -(index * intexStepSize).toPrecision(1)
                font.pixelSize                              : 12
                color                                       : axisLineColor
                rotation                                    : -90
            }
        }
    }

    // Label for positive y-axis
    Repeater {
        model                                               : Math.floor(axisLength / stepSizeOfCoordinatSystem) + 1
        Rectangle {
            width                                           : 1
            height                                          : 15
            anchors.horizontalCenter                        : parent.horizontalCenter
            x                                               : centerPointX
            y                                               : centerPointY - (index * stepSizeOfCoordinatSystem) - (height / 2)
            rotation                                        : 90
            color                                           : axisLineColor
            opacity                                         : 0.5

            Text {
                anchors.bottom                              : parent.top
                anchors.bottomMargin                        : 3
                anchors.horizontalCenter                    : parent.horizontalCenter
                text                                        : (index * intexStepSize) === 0 ? "" : (index * intexStepSize).toFixed(1)
                font.pixelSize                              : 12
                color                                       : axisLineColor
                rotation                                    : -90
            }
        }
    }

    // Label for negative y-axis
    Repeater {
        model                                               : Math.floor(axisLength / stepSizeOfCoordinatSystem) + 1
        Rectangle {
            width                                           : 1
            height                                          : 15
            anchors.horizontalCenter                        : parent.horizontalCenter
            x                                               : centerPointX
            y                                               : centerPointY + (index * stepSizeOfCoordinatSystem) - (height / 2)
            rotation                                        : 90
            color                                           : axisLineColor
            opacity                                         : 0.5

            Text {
                anchors.bottom                              : parent.top
                anchors.bottomMargin                        : 3
                anchors.horizontalCenter                    : parent.horizontalCenter
                text                                        : -(index * intexStepSize) === 0 ? "" : -(index * intexStepSize).toFixed(1)
                font.pixelSize                              : 12
                color                                       : axisLineColor
                rotation                                    : -90
            }
        }
    }

    Rectangle {
        width                                               : 10
        height                                              : width
        radius                                              : width
        x                                                   : centerPointX - (width/2) + (stepSizeOfCoordinatSystem * pointX * divisionValue)
        y                                                   : centerPointY - (width/2) - (stepSizeOfCoordinatSystem * pointY * divisionValue)
        color                                               : "blue"
        visible                                             : connectionStatus
        Text {
            anchors.bottom                                  : parent.top
            anchors.bottomMargin                            : parent.width / 2
            anchors.horizontalCenter                        : parent.horizontalCenter
            text                                            : "x: " + pointX.toFixed(2) + "\n" + "y: " + pointY.toFixed(2)
            font.pixelSize                                  : (parent.width / 10) * 12
            color                                           : "black"
        }
    }
}
