import QtQuick 2.0

Rectangle {
    property real startX                                : 25
    property real startY                                : 2
    property real endX                                  : 400
    property real endY                                  : 2
    property real lineWidth                             : 2
    property color lineColor                            : "#0F1035"
    property real triangleSize                          : 25

    width                                               : Math.sqrt((endX - startX) * (endX - startX) + (endY - startY) * (endY - startY))
    height                                              : lineWidth

    rotation                                            : Math.atan2(endY - startY, endX - startX) * 180 / Math.PI

    x                                                   : startX
    y                                                   : startY

    // line
    Rectangle {
        width                                           : parent.width
        height                                          : parent.height
        color                                           : lineColor
    }

    // triangle at startX, startY
    Canvas {
        width                                           : triangleSize
        height                                          : triangleSize
        x                                               : -triangleSize / 2 - 13
        y                                               : -triangleSize / 2
        rotation                                        : -90
        Canvas {
            width                                       : triangleSize
            height                                      : triangleSize
            onPaint                                     : {
                var ctx = getContext("2d")
                ctx.beginPath()
                ctx.moveTo(triangleSize / 2, 0)
                ctx.lineTo(0, triangleSize)
                ctx.lineTo(triangleSize, triangleSize)
                ctx.closePath()
                ctx.fillStyle = lineColor
                ctx.fill()
            }
        }
    }

    // triangle at endX, endY
    Canvas {
        width                                           : triangleSize
        height                                          : triangleSize
        x                                               : parent.width - triangleSize / 2 + 11
        y                                               : parent.height - triangleSize / 2
        rotation                                        : 90
        onPaint                                         : {
            var ctx = getContext("2d")
            ctx.beginPath()
            ctx.moveTo(triangleSize / 2, 0)
            ctx.lineTo(0, triangleSize)
            ctx.lineTo(triangleSize, triangleSize)
            ctx.closePath()
            ctx.fillStyle = lineColor
            ctx.fill()
        }
    }
}
