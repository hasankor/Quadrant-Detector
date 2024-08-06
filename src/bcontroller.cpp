#include "Enums.h"
#include "bcontroller.h"
#include <QDateTime>
#include <QQmlContext>
#include <QTimer>
#include <QQmlEngine>
#include <QApplication>
#include <QSerialPortInfo>
#include <cstring>
#include <cstdint>

union BytesToFloat {
    uint8_t bytes[4];
    float floatValue;
};


BController::BController(QWindow *parent)
    : QQuickView(parent)
    , mSerialMessage("")
    , mConnectionStatus(false)
    , mXAxisValue(0)
    , mYAxisValue(0)
{
    //begin: object registery
    qmlRegisterType<BController>();
    //end:

    rootContext()->setContextProperty("controller", this);

    mSerialCommunication = new SerialCommunication();
    QObject::connect(mSerialCommunication, &SerialCommunication::newMessageFromRemote, this, [this](QByteArray pDatas){
        deserializeMessage(pDatas);
    });

    setResizeMode(SizeRootObjectToView);

    connect(this, &BController::statusChanged, this, [=](QQuickView::Status pStatus){
        qDebug() << "qml status changed" << pStatus;
        if(pStatus == QQuickView::Ready)
            init();
    });

    setSource(QUrl(QStringLiteral("qrc:/ui/qml/main.qml")));
}

BController::~BController()
{
    if(mSerialCommunication){
        setConnectionStatus(false);
        mSerialCommunication->stop();
        mSerialCommunication->deleteLater();
    }
}

void BController::init()
{
    QTimer::singleShot(10, this, [](){
        availablePorts();
    });
}

void BController::deserializeMessage(QByteArray pMessage)
{
    if (pMessage.size() != 8) {
        qDebug() <<"!!!!!!!!!!!!!!!Message size is incorrect!!!!!!!!!!!!!!!      Message Size: "<< pMessage.size();
        return;
    }

    QByteArray xBytes = pMessage.mid(0, 4);
    QByteArray yBytes = pMessage.mid(4, 8);

    BytesToFloat converter;

    std::memcpy(converter.bytes, xBytes.constData(), 4);
    mXAxisValue = converter.floatValue;

    std::memcpy(converter.bytes, yBytes.constData(), 4);
    mYAxisValue = converter.floatValue;

    setXAxisValue(mXAxisValue);
    setYAxisValue(mYAxisValue);

    //    qDebug() << "mXAxisValue:" << mXAxisValue;
    //    qDebug() << "mYAxisValue:" << mYAxisValue;

}

void BController::openCloseSerialPort(bool pEjectStatus)
{
    if(!pEjectStatus){
        mSerialCommunication->setPortName(mSelectedPortName);
        mSerialCommunication->setBaudRate(QSerialPort::BaudRate::Baud115200);
        mSerialCommunication->setDataBits(QSerialPort::DataBits::Data8);
        mSerialCommunication->setParity(QSerialPort::Parity::NoParity);
        mSerialCommunication->setFlowControl(QSerialPort::FlowControl::NoFlowControl);
        mSerialCommunication->setStopBits(QSerialPort::StopBits::OneStop);
        mSerialCommunication->start();
        setConnectionStatus(true);
    }
    else{
        mSerialCommunication->stop();
        setConnectionStatus(false);
    }
}

void BController::setSelectedPortName(QString pSelectedPortName)
{
    mSelectedPortName = pSelectedPortName;

    // for linux os
    QString tCommand = "echo kor186041 | sudo -S chmod 666 " + (mSelectedPortName.contains("/dev/") ? mSelectedPortName : (mSelectedPortName = "/dev/" + mSelectedPortName)) ;
    qDebug() << "CoolerManager==> tCommand:" << tCommand;
    system(tCommand.toStdString().c_str());
}

void BController::setXAxisValue(float xAxisValue)
{
    mXAxisValue = xAxisValue;
    emit xAxisValueChanged(mXAxisValue);
}

void BController::setYAxisValue(float yAxisValue)
{
    mYAxisValue = yAxisValue;
    emit yAxisValueChanged(mYAxisValue);
}

void BController::setConnectionStatus(bool connectionStatus)
{
    if (mConnectionStatus == connectionStatus)
        return;

    mConnectionStatus = connectionStatus;
    emit connectionStatusChanged(mConnectionStatus);
}

void BController::setSerialMessage(QString serialMessage)
{
    if (mSerialMessage == serialMessage)
        return;

    mSerialMessage = serialMessage;
    emit serialMessageChanged(mSerialMessage);
}

QVariant BController::availablePorts()
{
    QList<QSerialPortInfo> tPortsAvailable = QSerialPortInfo::availablePorts();
    QStringList tAvailablePortsName;

    for(const QSerialPortInfo& portInfo : tPortsAvailable) {
        tAvailablePortsName << portInfo.portName();
    }

    return QVariant::fromValue(tAvailablePortsName);
}

float BController::xAxisValue() const
{
    return mXAxisValue;
}

float BController::yAxisValue() const
{
    return mYAxisValue;
}


bool BController::connectionStatus() const
{
    return mConnectionStatus;
}


QString BController::serialMessage() const
{
    return mSerialMessage;
}


