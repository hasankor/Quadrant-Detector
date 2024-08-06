#include "serialcommunication.h"
#include <QCoreApplication>
#include <QAbstractEventDispatcher>

SerialCommunication::SerialCommunication(QString pPortName, QSerialPort::BaudRate pBaudRate, QSerialPort::DataBits pDataBits, QSerialPort::Parity pParity, QSerialPort::FlowControl pFlowControl, QSerialPort::StopBits pStopBits)
    : AThread()
    , mPortName(pPortName)
    , mBaudRate(pBaudRate)
    , mDataBits(pDataBits)
    , mParity(pParity)
    , mFlowControl(pFlowControl)
    , mStopBits(pStopBits)

{

}

SerialCommunication::SerialCommunication()
{

}

void SerialCommunication::send(QByteArray data)
{
    if(!isRunning()){
        qDebug() << this->objectName() << "SerialCommunication::send SerialSenderReceiver not working";
        emit errorOccurred("Serial Communication not working");
        return;
    }
    if(!makeMethodRunOnThisThread("send", Q_ARG(QByteArray, data))){
        return;
    }

    if(mSerialPort->write(data) == -1){
        qDebug() << this->objectName() << "SerialCommunication::send QByteArray error while sending data " << mSerialPort->error();
        emit errorOccurred(mSerialPort->errorString());
    }
}

void SerialCommunication::mainLoop()
{
    mSerialPort = new QSerialPort(this);
    mSerialPort->setPortName(mPortName);

    if(!mSerialPort->setBaudRate(mBaudRate)){
        qDebug() << this->objectName() << "SerialCommunication::bind setBaudRate error " <<  mSerialPort->errorString();
        emit errorOccurred(mSerialPort->errorString()+ " " + QString(mBaudRate));
        return;
    }
    if(!mSerialPort->setDataBits(mDataBits)){
        qDebug() << this->objectName() << "SerialCommunication::bind setDataBits error " <<  mSerialPort->errorString();
        emit errorOccurred(mSerialPort->errorString()+ " " + QString(mDataBits));
        return;
    }
    if(!mSerialPort->setParity(mParity)){
        qDebug() << this->objectName() << "SerialCommunication::bind setParity error " <<  mSerialPort->errorString();
        emit errorOccurred(mSerialPort->errorString()+ " " + QString(mParity));
        return;
    }
    if(!mSerialPort->setFlowControl(mFlowControl)){
        qDebug() << this->objectName() << "SerialCommunication::bind setFlowControl error " <<  mSerialPort->errorString();
        emit errorOccurred(mSerialPort->errorString()+ " " + QString(mFlowControl));
        return;
    }
    if(!mSerialPort->setStopBits(mStopBits)){
        qDebug() << this->objectName() << "SerialCommunication::bind setStopBits error " <<  mSerialPort->errorString();
        emit errorOccurred(mSerialPort->errorString() + " " + QString(mStopBits));
        return;
    }
    if(!mSerialPort->open(QIODevice::ReadWrite)){
        qDebug() << this->objectName() << "SerialCommunication::bind open error " <<  mSerialPort->errorString();
        emit errorOccurred(mSerialPort->errorString() + " " + mPortName);
        return;
    }

    QObject::connect(mSerialPort, &QSerialPort::errorOccurred, this, &SerialCommunication::error);
    QObject::connect(mSerialPort, &QSerialPort::readyRead, this, &SerialCommunication::readyRead);

    while(!getShouldStop()) {
        QThread::currentThread()->eventDispatcher()->processEvents(QEventLoop::WaitForMoreEvents);
    }
    mSerialPort->close();
    mSerialPort->deleteLater();
}

void SerialCommunication::error(QSerialPort::SerialPortError error)
{
    if(error != QSerialPort::TimeoutError){
        qDebug() << this->objectName() << "SerialCommunication::errorOccurred error " << error;
        emit errorOccurred(QString(error));
    }
}

void SerialCommunication::readyRead()
{
    emit newMessageFromRemote(mSerialPort->readAll());
}

void SerialCommunication::setStopBits(const QSerialPort::StopBits &stopBits)
{
    mStopBits = stopBits;
}

void SerialCommunication::setFlowControl(const QSerialPort::FlowControl &flowControl)
{
    mFlowControl = flowControl;
}

void SerialCommunication::setParity(const QSerialPort::Parity &parity)
{
    mParity = parity;
}

void SerialCommunication::setDataBits(const QSerialPort::DataBits &dataBits)
{
    mDataBits = dataBits;
}

void SerialCommunication::setBaudRate(const QSerialPort::BaudRate &baudRate)
{
    mBaudRate = baudRate;
}

void SerialCommunication::setPortName(const QString &portName)
{
    mPortName = portName;
}


