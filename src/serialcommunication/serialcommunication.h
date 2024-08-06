#ifndef SERIALCOMMUNICATION_H
#define SERIALCOMMUNICATION_H

#include <thread/athread.h>
#include <QSerialPort>

class SerialCommunication : public AThread
{
    Q_OBJECT
public:
    SerialCommunication(QString pPortName, QSerialPort::BaudRate pBaudRate, QSerialPort::DataBits pDataBits = QSerialPort::DataBits::Data8,
                          QSerialPort::Parity pParity = QSerialPort::Parity::NoParity, QSerialPort::FlowControl pFlowControl = QSerialPort::FlowControl::NoFlowControl,
                          QSerialPort::StopBits pStopBits  = QSerialPort::StopBits::OneStop);
    SerialCommunication();

    void setPortName(const QString &portName);

    void setBaudRate(const QSerialPort::BaudRate &baudRate);

    void setDataBits(const QSerialPort::DataBits &dataBits);

    void setParity(const QSerialPort::Parity &parity);

    void setFlowControl(const QSerialPort::FlowControl &flowControl);

    void setStopBits(const QSerialPort::StopBits &stopBits);

signals:
    void errorOccurred(QString pError);
    void newMessageFromRemote(QByteArray message);

public slots:
    void send(QByteArray data);

    // AThread interface
protected:
    void mainLoop() override;

private slots:
    void error(QSerialPort::SerialPortError error);
    void readyRead();


private:
    QString mPortName;
    QSerialPort::BaudRate mBaudRate;
    QSerialPort::DataBits mDataBits;
    QSerialPort::Parity mParity;
    QSerialPort::FlowControl mFlowControl;
    QSerialPort::StopBits mStopBits;
    QSerialPort *mSerialPort;
};

#endif // SERIALCOMMUNICATION_H
