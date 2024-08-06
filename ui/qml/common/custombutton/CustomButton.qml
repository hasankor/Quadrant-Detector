import QtQuick 2.0
import QtQuick.Controls 2.0

Item {

    id                          :   customButton

    property alias txt          :   customButtonText
    property int font           :   12
    property real radius        :   0
    property string text        :   ""
    property string color       :   ""
    property string source      :   ""
    property bool fontBold      :   true
    property real bgOpacity     :   1
    property bool isHovered     :   false
    property string textColor   :   "#F8FAE5"
    property string borderColor :   "transparent"

    signal clicked()
    signal pressed()
    signal released()

    Rectangle
    {
        id                      :   customButtonArea
        anchors.fill            :   parent
        color                   :   customButton.color
        opacity                 :   customButton.bgOpacity
        radius                  :   customButton.radius
        border.color            :   customButton.borderColor
        border.width            :   1
    }

    Text
    {
        id                      :   customButtonText
        text                    :   customButton.text
        color                   :   customButton.textColor
        font.bold               :   customButton.fontBold
        font.pixelSize          :   customButton.font
        anchors.fill            :   parent
        horizontalAlignment     :   Qt.AlignHCenter
        verticalAlignment       :   Qt.AlignVCenter
        wrapMode                :   Text.WrapAnywhere
        z                       :   2
        scale                   :   Math.min(1, parent.width / contentWidth)
    }

    Image
    {
        id                      :    customButtonImage
        source                  :    customButton.source
        opacity                 :    customButton.enabled ? 1 : .4
        width                   :    customButton.width
        height                  :    customButton.height
        anchors.centerIn        :    parent
        transformOrigin         :    Item.Center
        fillMode                :    Image.PreserveAspectFit
        sourceSize.width        :    customButtonImage.width
        sourceSize.height       :    customButtonImage.height
    }

    MouseArea
    {
        id                      :   mouseArea
        anchors.fill            :   parent
        onClicked               :   {customButton.clicked()}
        onPressed               :   {customButton.pressed()}
        onReleased              :   {customButton.released()}
        onEntered               :   { isHovered = true}
        onExited                :   { isHovered = false}
    }
}
